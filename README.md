<div align="center">
  <br/>
  <img src="./assets/img/jamesboard_logo.png" alt="jamesboard" width="200px" height="200px" />
  <h1>James Board</h1>
  <br/>
</div>

## 목차

1. [**JamesBoard App 소개**](#1)
1. [**기술 스택**](#2)
1. [**주요 기능**](#3)
1. [**프로젝트 구성도**](#4)
1. [**영상 포트폴리오**](#5)
1. [**개발 팀 소개**](#6)
1. [**개발 기간 및 일정**](#7)

<br/><br/>

## 🕵️ JamesBoard App 소개

보드게임 카페에 가면 수많은 보드게임 중 어떤 게임을 선택해야 할지 고민한 경험, 다들 있으시죠?

**JamesBoard**는 바로 이 문제에서 출발했습니다.
우리는 보드게임을 고르는 데 어려움을 겪은 경험을 바탕으로, 사용자에게 맞춤형 보드게임을 추천해주는 서비스를 기획하게 되었습니다.

**주요 기능**
- 사용자의 선호 장르, 플레이 인원, 난이도, 시간 등 취향에 맞는 보드게임 추천
- 다른 사용자들의 리뷰 및 평가 기반 추천
- 플레이 시간, 인기 순위 등 다양한 데이터 기반 추천 기능

<br/>

<img src="./assets/img/cafe.png" alt="jamesboard" />

<br/><br/>

## 🛠 기술 스택

<table>
  <tbody>
    <tr>
      <td><strong>App</strong></td>
      <td>
        <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white">
        <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white">
      </td>
    </tr>
    <tr>
      <td><strong>Back-end</strong></td>
      <td>
        <img src="https://img.shields.io/badge/Java-007396?style=for-the-badge&logo=java&logoColor=white">
        <img src="https://img.shields.io/badge/Spring_Boot-6DB33F?style=for-the-badge&logo=spring-boot&logoColor=white">
        <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white">
        <img src="https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white">
        <img src="https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white">
        <img src="https://img.shields.io/badge/Swagger-85EA2D?style=for-the-badge&logo=swagger&logoColor=black">
        <img src="https://img.shields.io/badge/Hibernate-59666C?style=for-the-badge&logo=hibernate&logoColor=white">
        <img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white">
        <img src="https://img.shields.io/badge/ChromaDB-FF4081?style=for-the-badge&logo=databricks&logoColor=white">
      </td>
    </tr>
    <tr>
      <td><strong>DevOps</strong></td>
      <td>
        <img src="https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white">
        <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white">
        <img src="https://img.shields.io/badge/Portainer-13BEF9?style=for-the-badge&logo=docker&logoColor=white">
        <img src="https://img.shields.io/badge/SonarQube-4E9BCD?style=for-the-badge&logo=sonarqube&logoColor=white">
      </td>
    </tr>
    <tr>
      <td><strong>Tools</strong></td>
      <td>
        <img src="https://img.shields.io/badge/GitLab-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white">
        <img src="https://img.shields.io/badge/Jira-0052CC?style=for-the-badge&logo=jira&logoColor=white">
        <img src="https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white">
        <img src="https://img.shields.io/badge/Mattermost-0058CC?style=for-the-badge&logo=mattermost&logoColor=white">
      </td>
    </tr>
  </tbody>
</table>

<br/><br/>

## 📌 주요 기능

#### 1️⃣ 사용자 로그인 및 온보딩

앱을 처음 사용하는 사용자에게는 9개의 보드게임 장르(파티, 전략, 경제, 모험, 롤플레잉, 가족, 추리, 전쟁, 추상전략) 중에서 선호하는 장르에 해당하는 게임을 하나 선택하도록 합니다. 이를 통해 **Cold Start** 문제를 해결하고, 사용자가 선택한 장르에 맞는 추천 게임 정보를 제공합니다.


|        **Login**         |      **onboarding**      |       **Recommend**       |
| :----------------------: | :----------------------: | :-----------------------: |
| <img src="./assets/gif/login.gif" height="400"> | <img src="./assets/gif/onboarding.gif" height="400"> | <img src="./assets/gif/recommend.gif" height="400"> |

<br>

#### 2️⃣ 보드게임

홈 화면에서는 사용자가 보드게임의 카테고리, 인원수, 난이도 등을 기준으로 게임 정보를 필터링하거나 검색할 수 있습니다. 또한, 각 게임에 대해 평점을 남길 수 있습니다.

|                      **Home**                      |                      **Rating**                      |
| :--------------------------------------------------------: | :---------------------------------------------------------: |
| <img src="./assets/gif/home.gif" height="400"> | <img src="./assets/gif/rating.gif" height="400"> |

<br>

#### 3️⃣ 챗봇

저희는 단순히 사용자에게 게임을 추천하는 것에 그치지 않고, 챗봇을 통해 게임에 대한 정보 제공과 추천 기능도 함께 제공합니다.

|                      **Chatbot**                      |
| :--------------------------------------------------------: |
| <img src="./assets/gif/chatbot.gif" height="400"> |


#### 4️⃣ 아카이브

|                      **Archive**                      |
| :--------------------------------------------------------: |
| <img src="./assets/gif/archive.gif" height="400"> |

#### 5️⃣ 내 정보

|                      **MyInfo**                      |
| :--------------------------------------------------------: |
| <img src="./assets/gif/mypage.gif" height="400"> |


<br/><br/><br/>

## 📁 프로젝트 구조

|                                    Architecture                                    |
| :--------------------------------------------------------------------------------: |
| <img src="./assets/img/jamesboard_architecture.png" alt="Architecture" width="1000px" /> |

|                                    ERD                                    |
| :-----------------------------------------------------------------------: |
| <img src="./assets/img/jamesboard_erd.png" alt="ERD" width="1000px" /> |

<br/><br/>

<div id="5"></div>

<br/><br/>

## 🎥 영상 포트폴리오

[**james board 영상 포트폴리오 바로가기**](https://youtu.be/LIxzq0-G3Dk)


<br/><br/>

## 🏅 개발 팀 소개

<table align="center">
  <tr>
    <td align="center" width="150px">
      <a href="https://github.com/dunblx05" target="_blank">
        <img src="./assets/img/d205_kdy.png" alt="김두영 프로필" />  
      </a>
    </td>
    <td align="center" width="150px">
      <a href="https://github.com/kdh4718" target="_blank">
        <img src="./assets/img/d205_kdh.png" alt="김동현 프로필" />
      </a>
    </td>
    <td align="center" width="150px">
      <a href="https://github.com/KR-ImPlant" target="_blank">
        <img src="./assets/img/d205_kms.png" alt="강민석 프로필" />
      </a>
    </td>
    <td align="center" width="150px">
      <a href="https://github.com/hyuun" target="_blank">
        <img src="./assets/img/d205_ksh.png" alt="김성현 프로필" />
      </a>
    </td>
    <td align="center" width="150px">
      <a href="https://github.com/gretea5" target="_blank">
        <img src="./assets/img/d205_pjh.png" alt="박장훈 프로필" />
      </a>
    </td>
    <td align="center" width="150px">
      <a href="https://github.com/SWisdom1108" target="_blank">
        <img src="./assets/img/d205_chw.png" alt="차현우 프로필" />
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
        김두영<br />BE & DevOps
    </td>
    <td align="center">
        김동현<br />App & Data
    </td>
    <td align="center">
        강민석<br />BE & AI
    </td>
    <td align="center">
        김성현<br />App
    </td>
    <td align="center">
        박장훈<br />App
    </td>
    <td align="center">
        차현우<br />BE & Data
    </td>
  </tr>
</table>

<br/><br/>

<div id="7"></div>

<br/><br/>

## ⏰ 개발 기간 및 일정

### [2/24] PJT 1주차 시작 및 팀 구성

- Notion 생성
- Jira 생성
- Convention 설정 (Git, Code, Naming)
- Code Convention 설정
- 빅데이터 추천 서비스 기획

### [~3/9] PJT 2주차

- API 명세서 작성
- ERD 구성
- DevOps 구성
- 빅데이터 수집 및 전처리
- Spring 서버 구현
- 콘텐츠 기반 필터링 로직 구현
- App UI/UX 디자인
- [3/14] 전문가 1차 미팅

### [~3/16] PJT 3주차

- APP UI/UX 개발
- FastAPI 서버 구현
- 하이브리드 필터링 로직 구현
- [3/21] 중간 발표

### [~3/23] PJT 4주차

- Spring, FastAPI 서버 기능 개선
- App 기능 개선
- [3/28] 전문가 2차 미팅

### [~3/30] PJT 5주차

- App Widget 개발
- 빅데이터 로직 기능 개선
- 콘텐츠 기반 필터링 Bug Fix
- 하이브리드 필터링 Bug Fix

### [~4/6] PJT 6주차

- 영상 포트폴리오 작성
- AI 챗봇 시스템 구성 및 구현
- App Bug Fix

### [~4/11] PJT 7주차

- App Bug Fix
- [4/8] 1차 QA
- [4/9] 2차 QA
- [4/10] 3차 QA
- [4/11] 최종 발표

<br/><br/>
