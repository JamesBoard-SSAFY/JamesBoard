# 지식 트리플 모델

from pydantic import BaseModel
from typing import List, Optional, Dict, Any

class KnowledgeTriple(BaseModel):
    """보드게임에 대한 사실을 표현하는 지식 트리플"""
    entity: str  # 게임 이름
    attribute: str  # 속성/특성
    value: str  # 값
    
    def as_kblam_format(self) -> str:
        """KBLaM 형식의 문자열로 변환"""
        return f"The {self.attribute} of {self.entity} is {self.value}."
    
    def as_tuple(self) -> tuple:
        """튜플 형식으로 변환"""
        return (self.entity, self.attribute, self.value)