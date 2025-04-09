# LLM API 호출 로직

# import os
# from typing import Dict, Any, List, Optional
# from openai import OpenAI

# class LLMClient:
#     """OpenAI GPT 모델과 통신하는 클라이언트"""
    
#     def __init__(self):
#         # API 키 설정
#         self.api_key = os.getenv("OPENAI_API_KEY")
#         # OpenAI 클라이언트 초기화
#         self.client = OpenAI(api_key=self.api_key)
#         # 사용할 모델 설정
#         self.model = "gpt-4o"
    
#     def generate(self, system_prompt: str, user_prompt: str, temperature: float = 0.7) -> str:
#         """
#         LLM에서 응답 생성
        
#         매개변수:
#             system_prompt: 어시스턴트 행동을 제어하는 시스템 프롬프트
#             user_prompt: 사용자 메시지
#             temperature: 무작위성 제어 (0-1)
            
#         반환:
#             생성된 텍스트 응답
#         """
#         try:
#             # API 호출
#             response = self.client.chat.completions.create(
#                 model=self.model,
#                 messages=[
#                     {"role": "system", "content": system_prompt},
#                     {"role": "user", "content": user_prompt}
#                 ],
#                 temperature=temperature
#             )
#             return response.choices[0].message.content
#         except Exception as e:
#             print(f"LLM API 호출 오류: {e}")
#             return "죄송합니다, 요청을 처리하는 중에 오류가 발생했습니다."

# boardgame-assistant/app/core/llm_client.py

import os
from openai import OpenAI
from dotenv import load_dotenv

# .env 파일 로드
load_dotenv(override=True)

class LLMClient:
    """OpenAI GPT 모델과 통신하는 클라이언트"""
    
    def __init__(self):
        # 환경 변수에서 API 키 로드
        self.api_key = os.getenv("OPENAI_API_KEY", "").strip()
        self.organization_id = os.getenv("OPENAI_ORGANIZATION_ID")
        
        # 프로젝트 키 감지 및 초기화
        if self.organization_id:
            self.client = OpenAI(api_key=self.api_key, organization=self.organization_id)
        else:
            self.client = OpenAI(api_key=self.api_key)
        
        # 사용할 모델 설정
        self.model = "gpt-4o"
    
    def generate(self, system_prompt: str, user_prompt: str, temperature: float = 0.7) -> str:
        """
        LLM에서 응답 생성
        
        매개변수:
            system_prompt: 어시스턴트 행동을 제어하는 시스템 프롬프트
            user_prompt: 사용자 메시지
            temperature: 무작위성 제어 (0-1)
            
        반환:
            생성된 텍스트 응답
        """
        try:
            # API 호출
            response = self.client.chat.completions.create(
                model=self.model,
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": user_prompt}
                ],
                temperature=temperature
            )
            return response.choices[0].message.content
        except Exception as e:
            print(f"LLM API 호출 오류: {e}")
            return "죄송합니다, 요청을 처리하는 중에 오류가 발생했습니다."