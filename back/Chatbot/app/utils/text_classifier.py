# app/utils/text_classifier.py

import re
from typing import List, Dict, Set

# --- 설정 (나중에 외부 파일이나 DB로 분리 가능) ---

# 강력한 게임 관련 키워드 (높은 점수)
STRONG_KEYWORDS: Set[str] = {
    "보드게임", "board game", "보겜", "테마게임", "전략게임", "파티게임", "가족게임",
    "유로게임", "아메리트래쉬", "워게임", "카드게임", "덱빌딩", "일꾼놓기",
    "주사위", "미니어처", "컴포넌트", "확장팩", "본판", "플레이", "게임 추천",
    "게임 규칙", "게임 설명", "룰북", "긱순위", "BGG", "코보게", "보드라이프"
}
STRONG_SCORE = 3

# 일반 게임 관련 키워드 (중간 점수)
MEDIUM_KEYWORDS: Set[str] = {
    "게임", "game", "추천", "recommend", "인원", "players", "규칙", "rules",
    "설명", "explain", "방법", "how to", "테마", "theme", "전략", "strategy",
    "협력", "cooperative", "경쟁", "competitive", "카드", "card", "주사위", "dice",
    "몇 명", "몇인", "시간", "duration", "난이도", "complexity", "초보", "beginner",
    "고수", "expert", "리플레이성", "replayability"
}
MEDIUM_SCORE = 2

# 약한 게임 관련 키워드 (낮은 점수, 다른 단서와 함께 사용)
WEAK_KEYWORDS: Set[str] = {
    "놀이", "플레이어", "뭐 할까", "재밌는 거", "같이 할", "취미", "모임", "game night"
}
WEAK_SCORE = 1

# 흔한 보드게임 제목 (매우 높은 점수) - 계속 추가/관리 필요
# 예시: 나중에 파일이나 DB에서 로드하는 것이 좋음
COMMON_GAME_TITLES: Set[str] = {
    "카탄", "catan", "티켓 투 라이드", "ticket to ride", "카르카손", "carcassonne",
    "윙스팬", "wingspan", "아줄", "azul", "글룸헤이븐", "gloomhaven", "팬데믹", "pandemic",
    "테라포밍 마스", "terraforming mars", "스플렌더", "splendor", "도미니언", "dominion",
    "클랭크", "clank", "루트", "root", "브라스", "brass", "아컴호러", "arkham horror",
    "세븐원더스", "7 wonders", "푸에르토 리코", "puerto rico", "하나비", "hanabi",
    "코드네임", "codenames", "딕싯", "dixit", "아그리콜라", "agricola",
    # ... (더 많은 게임 추가)
}
GAME_TITLE_SCORE = 5

# 게임 관련 질문 패턴 (정규식)
# 예: "X명 추천", "Y 게임 규칙", "Z 같은 게임"
GAME_QUERY_PATTERNS: Dict[str, int] = {
    r"\b(\d+|[몇두세네다섯여섯일곱여덟아홉열])\s*(명|인|인용)\s*(게임|추천|할만한 거|)\b": 4, # "2명 게임", "몇 명 추천"
    r"\b(게임|game)\s+(규칙|룰|방법|설명|하는 법)\b": 4,              # "게임 규칙", "game 설명"
    r"\b(추천)\s*(좀|해줘|해주세요)\b": 3,                             # "추천 좀", "추천해주세요"
    r"\b(어떤|무슨)\s+(게임|game)\b": 3,                               # "어떤 게임"
    r"\b\w+\s*(같은|비슷한)\s*(게임|game)\b": 3,                        # "카탄 같은 게임"
    r"\b(초보|입문|처음).*(추천|게임|)\b": 3                           # "초보 추천", "입문 게임"
}
# ---------------------------------------------

def is_game_related_query(query: str) -> bool:
    """
    사용자 질문이 보드게임과 관련되었는지 판단합니다. (점수 기반)

    Args:
        query: 사용자 입력 문자열

    Returns:
        게임 관련 질문이면 True, 아니면 False
    """
    if not query or not query.strip():
        return False

    query_lower = query.lower() # 소문자 변환 및 공백 제거된 쿼리
    query_normalized = re.sub(r'\s+', ' ', query_lower).strip() # 연속 공백 제거

    score = 0
    matched_keywords: Set[str] = set() # 중복 점수 방지

    # 1. 강력한 키워드 체크
    for keyword in STRONG_KEYWORDS:
        if keyword in query_normalized and keyword not in matched_keywords:
            score += STRONG_SCORE
            matched_keywords.add(keyword)
            # print(f"[DEBUG] Strong keyword match: {keyword}, Score: +{STRONG_SCORE} -> {score}")

    # 2. 중간 키워드 체크
    for keyword in MEDIUM_KEYWORDS:
        # 정확한 단어 매칭 (예: "game"이 "gamer"에 포함되지 않도록)
        # \b 는 단어 경계를 의미 (공백, 문장 부호 등)
        if re.search(r'\b' + re.escape(keyword) + r'\b', query_normalized) and keyword not in matched_keywords:
            score += MEDIUM_SCORE
            matched_keywords.add(keyword)
            # print(f"[DEBUG] Medium keyword match: {keyword}, Score: +{MEDIUM_SCORE} -> {score}")

    # 3. 약한 키워드 체크
    for keyword in WEAK_KEYWORDS:
        if re.search(r'\b' + re.escape(keyword) + r'\b', query_normalized) and keyword not in matched_keywords:
            score += WEAK_SCORE
            matched_keywords.add(keyword)
            # print(f"[DEBUG] Weak keyword match: {keyword}, Score: +{WEAK_SCORE} -> {score}")

    # 4. 게임 제목 언급 체크
    for title in COMMON_GAME_TITLES:
        if title in query_normalized and title not in matched_keywords:
            score += GAME_TITLE_SCORE
            matched_keywords.add(title) # 게임 제목도 중복 점수 방지
            # print(f"[DEBUG] Game title match: {title}, Score: +{GAME_TITLE_SCORE} -> {score}")
            # 게임 제목이 언급되면 관련성이 매우 높으므로, 바로 True 반환도 고려 가능
            # return True

    # 5. 특정 질문 패턴 체크 (정규식)
    for pattern, pattern_score in GAME_QUERY_PATTERNS.items():
        if re.search(pattern, query_normalized):
            score += pattern_score
            # print(f"[DEBUG] Pattern match: {pattern}, Score: +{pattern_score} -> {score}")
            # 패턴 매칭은 중복 점수를 허용할 수도 있음 (예: "2명 게임 추천"은 두 패턴과 맞을 수 있음)
            # 여기서는 일단 한 번만 추가

    # 최종 점수 기반 판단 (임계값 조정 필요)
    # 이 임계값(threshold)은 테스트를 통해 적절히 조절해야 합니다.
    threshold = 3 # 예시 임계값 (최소 MEDIUM 키워드 하나 또는 WEAK 키워드 여러 개 등)

    # print(f"[DEBUG] Final Score: {score}, Threshold: {threshold}")

    return score >= threshold

# --- 테스트 예시 ---
if __name__ == "__main__":
    test_queries = [
        "보드게임 추천해줘",                           # True (Strong keyword, Pattern)
        "카탄 하는 법 알려줘",                       # True (Game title, Pattern)
        "2명이서 할만한 거 뭐 있어?",                  # True (Pattern, Weak keyword)
        "재밌는 파티 게임 없어?",                     # True (Strong keyword, Medium keyword)
        "What are the rules for Ticket to Ride?", # True (Game title, Medium keyword)
        "그냥 재밌는 이야기 해줘",                   # False
        "오늘 날씨 어때?",                           # False
        "플레이스테이션 게임 추천",                   # False (구분 필요 - 현재 로직으론 True 가능성 있음. 개선 필요)
        "규칙이 간단한 게임",                       # True (Medium keyword, Pattern)
        "주사위 굴리는 게임 좋아",                   # True (Strong keyword, Medium keyword)
        "글룸헤이븐 확장팩 나왔어?",                  # True (Game title, Strong keyword)
        "3인 추천",                                # True (Pattern)
        "이 게임 어때?",                           # False (모호함) -> 개선 가능: 이전 대화 문맥 필요
        "game night ideas",                     # True (Weak keyword)
        "strategy board game for 4 players",    # True (Medium, Strong, Pattern)
        "music recommendations",                # False
    ]

    for q in test_queries:
        result = is_game_related_query(q)
        print(f"Query: \"{q}\" -> Related: {result}")