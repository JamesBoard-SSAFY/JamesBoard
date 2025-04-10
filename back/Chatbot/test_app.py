# 메인 chainlit 애플리케이션 파일 (app.py 또는 현재 위치)

import os
import logging
import chainlit as cl
from dotenv import load_dotenv
from app.core.kblam_manager import SimplifiedKBLaM
from app.core.llm_client import LLMClient
from app.utils.prompt_templates import get_q_system_prompt, get_recommendation_prompt, get_comparison_prompt
from app.utils.text_classifier import is_game_related_query

# 로깅 설정
logging.basicConfig(level=logging.DEBUG, 
                   format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                   handlers=[logging.FileHandler("chainlit_debug.log"), logging.StreamHandler()])
logger = logging.getLogger(__name__)

# 환경 변수 로드
load_dotenv()
logger.info("환경 변수 로드 완료")
logger.debug(f"CHROMA_PERSIST_DIR: {os.environ.get('CHROMA_PERSIST_DIR')}")
logger.debug(f"EMBEDDING_MODEL_NAME: {os.environ.get('EMBEDDING_MODEL_NAME')}")
logger.debug(f"OPENAI_API_KEY 존재 여부: {bool(os.environ.get('OPENAI_API_KEY'))}")

# KBLaM 및 LLM 클라이언트 초기화
try:
    logger.info("KBLaM 초기화 시작")
    kblam = SimplifiedKBLaM(top_k=5)
    logger.info("KBLaM 초기화 완료")
    
    logger.info("LLM 클라이언트 초기화 시작")
    llm_client = LLMClient()
    logger.info("LLM 클라이언트 초기화 완료")
except Exception as e:
    logger.error(f"초기화 중 오류 발생: {str(e)}", exc_info=True)
    raise

@cl.on_chat_start
async def start():
    """채팅 시작 시 실행"""
    await cl.Message(
        content="안녕하세요! MI6의 Q입니다. 보드게임에 관한 질문이 있으시면 언제든 물어보세요. 어떤 게임을 찾고 계신가요?",
        author="Q",
    ).send()
    
    # 채팅 모드 설정 (기본값: 일반)
    cl.user_session.set("chat_mode", "general")

@cl.on_message
async def on_message(message: cl.Message):
    """사용자 메시지 수신 시 실행"""
    query = message.content
    chat_mode = cl.user_session.get("chat_mode")
    logger.info(f"받은 메시지: '{query}', 모드: {chat_mode}")
    
    # 채팅 모드 변경 명령 처리
    if query.startswith("/mode"):
        try:
            mode = query.split(" ")[1].strip().lower()
            if mode in ["general", "recommendation", "comparison"]:
                cl.user_session.set("chat_mode", mode)
                mode_descriptions = {
                    "general": "일반 질의응답 모드",
                    "recommendation": "게임 추천 특화 모드",
                    "comparison": "게임 비교 특화 모드"
                }
                await cl.Message(
                    content=f"채팅 모드를 '{mode_descriptions[mode]}'로 변경했습니다.",
                    author="시스템",
                ).send()
            else:
                await cl.Message(
                    content="지원되는 모드: general, recommendation, comparison",
                    author="시스템",
                ).send()
        except:
            await cl.Message(
                content="모드 변경 형식: /mode [모드이름]",
                author="시스템",
            ).send()
        return
    
    # 게임 관련 질문인지 정교하게 확인 (점수 기반 분류기 사용)
    is_game_query = is_game_related_query(query)
    logger.info(f"게임 관련 질문 여부: {is_game_query}")
    
    # 일반 대화 - 게임 관련 아님 && general 모드일 때만
    if not is_game_query and chat_mode == "general":
        logger.info("일반 대화로 분류됨 - 벡터 검색 없이 진행")
        # 일반 대화는 벡터 검색 없이 LLM만 사용
        try:
            basic_prompt = get_q_system_prompt() + "\n일반 대화에는 Q 캐릭터로 간략히 응답해주되, 가능하면 대화를 보드게임 질문으로 유도해주세요."
            response = llm_client.generate(
                system_prompt=basic_prompt,
                user_prompt=f"User Question: {query}"
            )
            await cl.Message(content=response, author="Q").send()
            return
        except Exception as e:
            logger.error(f"LLM 응답 생성 중 오류 발생: {str(e)}", exc_info=True)
            await cl.Message(
                content="응답 생성 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.",
                author="시스템",
            ).send()
            return
    
    # 게임 관련 질문 또는 전문 모드인 경우 - 벡터 검색 수행
    with cl.Step(name="벡터 검색", show_input=False) as step:
        # 채팅 모드에 맞는 프롬프트 선택
        if chat_mode == "recommendation":
            system_prompt = get_recommendation_prompt()
            logger.debug("추천 모드 프롬프트 선택됨")
        elif chat_mode == "comparison":
            system_prompt = get_comparison_prompt()
            logger.debug("비교 모드 프롬프트 선택됨")
        else:
            system_prompt = get_q_system_prompt()
            logger.debug("일반 모드 프롬프트 선택됨")
        
        step.input = f"{chat_mode} 모드 활성화"
        
        # 진행 상태 메시지
        search_msg = await cl.Message(content="보드게임 데이터베이스 검색 중...", author="시스템").send()
        
        try:
            # KBLaM으로 관련 트리플 검색 (한 번만 수행)
            logger.info(f"벡터 검색 시작: '{query}'")
            relevant_triples = kblam.retrieve_relevant_triples(query)
            logger.info(f"벡터 검색 완료: {len(relevant_triples)}개 트리플 발견")
            
            if relevant_triples:
                logger.debug(f"첫 번째 트리플: {relevant_triples[0]}")
            else:
                logger.warning("검색된 트리플이 없습니다")
                
            # 검색된 트리플 표시
            step.output = f"검색된 트리플: {len(relevant_triples)}개"
            
            # 트리플에서 게임 정보 추출
            games = {}
            for triple in relevant_triples:
                entity = triple.entity
                if entity not in games:
                    games[entity] = {"name": entity}
                
                games[entity][triple.attribute] = triple.value
                
            logger.debug(f"추출된 게임 정보: {games}")
            
            # 검색 메시지 업데이트 또는 삭제 (수정된 부분)
            await search_msg.remove()
            await cl.Message(content=f"보드게임 데이터베이스에서 {len(relevant_triples)}개의 정보를 찾았습니다.", author="시스템").send()
            
        except Exception as e:
            logger.error(f"벡터 검색 중 오류 발생: {str(e)}", exc_info=True)
            await cl.Message(
                content=f"검색 중 오류가 발생했습니다: {str(e)}", 
                author="시스템"
            ).send()
            return
    
    # 결과 표시
    if relevant_triples:
        # 추출된 게임 정보 표시 (추천 모드에서만)
        if chat_mode == "recommendation" and len(games) > 0:
            with cl.Step(name="검색된 게임", show_input=False) as step:
                game_info = []
                for game_name, game_data in games.items():
                    game_info.append(f"- **{game_name}**")
                    for attr, value in game_data.items():
                        if attr != "name":
                            game_info.append(f"  - {attr}: {value}")
                
                step.output = "\n".join(game_info)
        
        try:
            # 이미 검색된 트리플을 재사용하여 LLM 응답 생성
            logger.info("LLM 응답 생성 시작")
            response = kblam.predict(
                query=query, 
                llm_client=llm_client, 
                system_prompt=system_prompt,
                pre_retrieved_triples=relevant_triples  # 트리플 재사용
            )
            logger.info(f"LLM 응답 생성 완료: {len(response)}자")
            logger.debug(f"생성된 응답 일부: {response[:100]}...")
            
            # 추천 모드에서는 구조화된 게임 카드 형태로 표시
            if chat_mode == "recommendation" and len(games) > 0:
                # 게임 카드 생성 및 표시
                elements = []
                for game_name, game_data in games.items():
                    # 카드에 표시할 정보 선별
                    card_content = []
                    for key in ["description", "minplayers", "maxplayers", "playtime", "weight", "category"]:
                        if key in game_data:
                            card_content.append(f"**{key}**: {game_data[key]}")
                    
                    # 다른 속성들도 추가
                    for k, v in game_data.items():
                        if k not in ["name", "description", "minplayers", "maxplayers", "playtime", "weight", "category"]:
                            card_content.append(f"**{k}**: {v}")
                    
                    elements.append(
                        cl.Card(
                            title=game_name,
                            content="\n".join(card_content),
                            url=f"https://boardgamegeek.com/geeksearch.php?action=search&q={game_name.replace(' ', '+')}"
                        )
                    )
                
                # 카드와 함께 응답 표시
                await cl.Message(
                    content=response, 
                    author="Q",
                    elements=elements
                ).send()
            else:
                # 일반 응답
                await cl.Message(content=response, author="Q").send()
                
        except Exception as e:
            logger.error(f"LLM 응답 생성 중 오류 발생: {str(e)}", exc_info=True)
            await cl.Message(
                content="응답 생성 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.",
                author="시스템",
            ).send()
    else:
        logger.warning("관련 게임 정보를 찾지 못함")
        # 게임 관련 질문이지만 정보를 찾지 못한 경우
        if is_game_query:
            no_result_msg = "죄송합니다만 007, 그 질문에 대한 관련 게임 정보를 데이터베이스에서 찾지 못했습니다. 다른 키워드나 게임을 물어보시겠어요?"
            await cl.Message(content=no_result_msg, author="Q").send()
        else:
            # 게임 관련 질문이 아닌데 recommendation/comparison 모드인 경우
            mode_specific_msg = "음, 보드게임과 관련 없는 질문인 것 같군요. 이 채널은 보드게임 정보 전용입니다. 어떤 게임에 관심이 있으신가요?"
            await cl.Message(content=mode_specific_msg, author="Q").send()

@cl.on_settings_update
async def setup_agent(settings):
    """설정 업데이트 시 실행"""
    logger.info(f"설정 업데이트: {settings}")