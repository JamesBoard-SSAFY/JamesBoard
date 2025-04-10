package com.board.jamesboard.domain.onboard.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.entity.User;
import com.board.jamesboard.db.repository.GameCategoryRepository;
import com.board.jamesboard.db.repository.GameRepository;
import com.board.jamesboard.db.repository.UserRepository;
import com.board.jamesboard.domain.onboard.dto.OnBoardResponseDto;
import com.board.jamesboard.domain.onboard.dto.PreferGameRequestDto;

import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor(onConstructor = @__(@Autowired))
@Transactional
public class OnBoardServiceImpl implements OnBoardService {

    private final GameCategoryRepository gameCategoryRepository;

    private final GameRepository gameRepository;

    private final UserRepository userRepository;

    @Override
    public List<OnBoardResponseDto> getOnBoardGames(String category) {

        List<Long> gameIdList;

        if ("파티".equals(category)) {
            gameIdList = List.of(178900L, 2944L, 63268L, 166384L, 156129L, 207764L, 2452L, 128882L, 277085L, 92415L, 
            17530L, 46213L, 13L, 133473L, 521L, 188834L, 30549L, 366013L, 220L, 2206051L, 
            39856L, 153938L, 811L, 84876L, 215L, 225694L, 10506L, 9220L, 8946L, 117959L);
        } 
        else if ("전략".equals(category)) {
            gameIdList = List.of(224517L, 174430L, 169786L, 31260L, 253344L, 284083L, 822L, 148228L, 215L, 478L, 
            153938L, 143741L, 7717L, 314040L, 12333L, 68448L, 324856L, 316554L, 220308L, 135779L, 
            19857L, 27173L, 25417L, 144592L, 133473L, 92415L, 364073L, 25613L, 217372L, 66362L);
        }
        else if ("경제".equals(category)) {
            gameIdList = List.of(235488L, 233770L, 171499L, 224517L, 167792L, 162886L, 246900L, 28720L, 183394L, 175914L, 
            284378L, 3076L, 184267L, 231733L, 2651L, 35677L, 125153L, 317985L, 171623L, 366161L, 
            310873L, 172386L, 4098L, 193340L, 154809L, 162082L, 13L, 145659L, 40628L, 12002L);
        }
        else if ("모험".equals(category)) {
            gameIdList = List.of(2093L, 2452L, 143741L, 233247L, 224517L, 161936L, 342942L, 174430L, 291457L, 220308L, 
            84876L, 177736L, 295770L, 205637L, 237182L, 199792L, 295947L, 184267L, 170216L, 31260L, 
            255984L, 205059L, 276025L, 366161L, 269385L, 55690L, 14996L, 9209L, 287954L, 104162L);
        }
        else if ("롤플레잉".equals(category)) {
            gameIdList = List.of(463L, 699L, 1465L, 2093L, 3955L, 6472L, 7717L, 31260L, 37111L, 68448L, 
            128882L, 131357L, 143741L, 156129L, 163166L, 167355L, 169786L, 171623L, 173346L, 182874L, 
            192291L, 194879L, 221107L, 230802L, 236457L, 284083L, 285774L, 316377L, 364073L, 366013L);
        }
        else if ("가족".equals(category)) {
            gameIdList = List.of(63268L, 2944L, 46213L, 178900L, 133473L, 2452L, 822L, 811L, 204583L, 29223L, 
            8946L, 98778L, 130592L, 39856L, 131260L, 266192L, 77034L, 21763L, 225981L, 9220L, 
            2389L, 17530L, 13L, 30549L, 13654L, 10506L, 269385L, 352515L, 241724L, 117959L);
        }
        else if ("추리".equals(category)) {
            gameIdList = List.of(130592L, 316554L, 84876L, 397598L, 205059L, 2651L, 244521L, 279537L, 225694L, 240980L, 
            178900L, 254640L, 281259L, 263918L, 77423L, 128882L, 31627L, 188834L, 224037L, 156129L, 
            318977L, 223321L, 203420L, 46213L, 39856L, 188866L, 181304L, 352515L, 135779L, 206051L);
        }
        else if ("전쟁".equals(category)) {
            gameIdList = List.of(42L, 71L, 93L, 6472L, 12333L, 14105L, 15987L, 17226L, 22827L, 25021L, 
            25613L, 40692L, 59294L, 63628L, 72125L, 73439L, 103343L, 115746L, 169786L, 170216L, 
            173346L, 187645L, 191189L, 199042L, 205896L, 221107L, 227935L, 314040L, 346703L, 397598L);
        }
        // 추상전략
        else {
            gameIdList = List.of(171L, 811L, 2093L, 2386L, 2389L, 2719L, 13654L, 21882L, 36218L, 36932L, 
            40834L, 70323L, 90419L, 96848L, 100901L, 103885L, 148949L, 159675L, 161936L, 182134L, 
            209010L, 209418L, 217372L, 218417L, 262712L, 266192L, 266524L, 295895L, 295947L, 13L);
        }
        
        // // Category 입력 받아서 게임ID 조회
        // List<Long> gameIdList = gameCategoryRepository.findByGameCategoryName(category)
        //         .stream()
        //         .map(gameCategory -> gameCategory.getGame().getGameId()) // Game 객체에서 ID 추출
        //         .toList();

        List<Game> games = gameRepository.findTop30ByGameIdInOrderByGameRank(gameIdList);

        return games.stream()
                .map(game -> new OnBoardResponseDto(game.getGameId(), game.getGameTitle())) // DTO 변환
                .toList();
    }

    @Override
    public Long updateUserPreferGame(Long userId, PreferGameRequestDto preferGameRequestDto) {

        // JWT 현재 userId 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        Long jwtUserId = Long.parseLong(authentication.getName());

        if(!jwtUserId.equals(userId)) {
            throw new AccessDeniedException("권한이 없습니다.");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Game preferGame = gameRepository.findById(preferGameRequestDto.getGameId())
                .orElseThrow(() -> new RuntimeException("Game not found"));

        // 3. preferGame 변경 (setter 없이 새로운 객체 생성)
        user.updatePreferGame(preferGame);

        return user.getUserId();
    }
}
