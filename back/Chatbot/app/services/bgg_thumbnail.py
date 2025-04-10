# app/services/bgg_thumbnail.py
import aiohttp
import logging
import xml.etree.ElementTree as ET
from typing import Optional

logger = logging.getLogger(__name__)

async def get_bgg_thumbnail(game_id: int) -> Optional[str]:
    """
    BoardGameGeek API에서 게임 썸네일 URL만 가져옵니다
    
    매개변수:
        game_id: BoardGameGeek 게임 ID
        
    반환:
        썸네일 URL 또는 None
    """
    try:
        logger.info(f"BGG API에서 게임 ID {game_id}의 썸네일 가져오는 중...")
        
        # API 요청 URL (thing 엔드포인트)
        url = f"https://boardgamegeek.com/xmlapi2/thing?id={game_id}"
        
        async with aiohttp.ClientSession() as session:
            async with session.get(url) as response:
                if response.status != 200:
                    logger.error(f"BGG API에서 오류 응답: {response.status}")
                    return None
                
                xml_content = await response.text()
        
        # XML 응답 파싱
        root = ET.fromstring(xml_content)
        
        # 아이템이 없는 경우
        if not root.findall('.//item'):
            logger.warning(f"게임 ID {game_id}에 대한 데이터를 찾을 수 없음")
            return None
        
        # 썸네일 URL 추출
        item = root.find('.//item')
        thumbnail_url = item.findtext('thumbnail')
        
        if thumbnail_url:
            logger.info(f"게임 ID {game_id}의 썸네일 URL 찾음: {thumbnail_url}")
            return thumbnail_url
        else:
            logger.warning(f"게임 ID {game_id}의 썸네일을 찾을 수 없음")
            return None
        
    except Exception as e:
        logger.error(f"게임 썸네일을 가져오는 중 오류 발생: {str(e)}", exc_info=True)
        return None


# ChatService 클래스에 통합할 수 있는 코드 조각:

# 1. ChatService 클래스 상단에 import 추가
# from app.services.bgg_thumbnail import get_bgg_thumbnail

# 2. handle_chat 메서드 내에서 다음과 같이 수정

# 추천 모드인 경우 썸네일과 게임 ID 추가
# thumbnail = None
# gameId = None
# if chat_type == "recommend" and games:
#     # 첫 번째 게임에 대한 정보 사용
#     first_game = list(games.values())[0]
#     game_name = first_game.get("name")
#     
#     # 게임 ID 찾기
#     # 1. 메타데이터에서 직접 ID를 찾는 경우
#     if "game_id" in first_game:
#         gameId = first_game.get("game_id")
#     # 2. 게임 이름으로 ID 매핑을 찾는 경우
#     elif game_name in self.GAME_NAME_TO_ID:
#         gameId = self.GAME_NAME_TO_ID.get(game_name)
#     # 3. 기본값: 목록에서 임의의 ID 선택
#     else:
#         import random
#         gameId = random.choice(self.GAME_IDS)
#     
#     # BGG API에서 썸네일 URL 가져오기
#     if gameId:
#         try:
#             # 외부 API에서 썸네일 가져오기
#             thumbnail = await get_bgg_thumbnail(gameId)
#         except Exception as e:
#             logger.error(f"썸네일 가져오기 오류: {str(e)}")
#             thumbnail = None
#     
#     # 썸네일을 가져오지 못한 경우 기본 URL 사용
#     if not thumbnail:
#         thumbnail = f"https://example.com/images/{game_name.lower().replace(' ', '_')}.jpg"