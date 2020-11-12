#!/usr/bin/ruby

# Array format:
#   [0] = youtube url
#   [1] = directory name

# --format bestaudio
AUDIO = [
    ["https://www.youtube.com/user/AaronClarey/videos", "aaron_clarey"],
    ["https://www.youtube.com/user/artofmanliness/videos", "art_of_manliness"],

    # Better Bachelor / Odd Man Out
    ["https://www.youtube.com/channel/UC9ctsJZ2aD1nCexfqj342NQ/videos", "better_bachelor"],
    ["https://www.youtube.com/channel/UC7JGB6SrWxxeU33FHvffBBg/videos", "better_bachelor/odd_man_out"],

    ["https://www.youtube.com/channel/UCtUId5WFnN82GdDy7DgaQ7w/videos", "better_ideas"],
    ["https://www.youtube.com/channel/UC5tEELgWBfKbA9fVPRzBzPQ/videos", "coach_red_pill"],
    ["https://www.youtube.com/channel/UCc7-Rr-wSO530znK2ny05JQ/videos", "donovan_sharpe"],
    ["https://www.youtube.com/watch?v=TJFhZIjTIhU&list=PL68d6MdnLpLs4HVxM5npoRzidNlMgZn_a", "george_bruno/daybreak_show"],
    ["https://www.youtube.com/c/JaymeEdwardsMedia/videos", "health_software_developer"],
    ["https://www.youtube.com/watch?v=L6dQH0CT3B8&list=PL7ukuCEjUSlxLH3WbxnlG8MlahVoPpfbz", "HuMAN"],
    ["https://www.youtube.com/watch?v=T5yyHZwTOpA&list=PLIBtb_NuIJ1wCrBmN2Z3jcQ4vvmOEi-7-", "prager_u/fireside_chat"],
    ["https://www.youtube.com/channel/UC-tLyAaPbRZiYrOJxAGB7dQ/videos", "pursuit_of_wonder"],

    # Richard Cooper (Entrepreneurs in Cars)
    ["https://www.youtube.com/watch?v=560SL5e3lQ8&list=PLMcVcytzH5GGM8e1RT72urO1HY17i8fqT", "richard_cooper/playing_to_win"],
    ["https://www.youtube.com/watch?v=ImjUfM5lli8&list=PLMcVcytzH5GHS5AtBy6YZqdHdO3sn3P0L", "richard_cooper/mens_dating_advice"],
    ["https://www.youtube.com/watch?v=n1JoMsDJqgw&list=PLMcVcytzH5GEkYN7-aGRMikLCbZ8YzSY2", "richard_cooper/money_advice"],
    ["https://www.youtube.com/watch?v=no7QSlMOrYc&list=PLMcVcytzH5GEZRHeDCeHPDY2HMeoNsS9n", "richard_cooper/self_care"],
    ["https://www.youtube.com/watch?v=O2KmvuzaCQ8&list=PLMcVcytzH5GFfyjstvv4G5rezVKc6tziI", "richard_cooper/entrepreneurial_and_bsuiness_tips"],
    ["https://www.youtube.com/watch?v=nV7B0Fzcl2w&list=PLMcVcytzH5GGEP8Do5l_iZkYdlArf_ZA3", "richard_cooper/red_pill_for_men"],
    ["https://www.youtube.com/watch?v=6jPh1oiOzAM&list=PLMcVcytzH5GHH2YMfJ1qcAZ2cMyBwtpjK", "richard_cooper/marriage"],
    ["https://www.youtube.com/watch?v=eQFNpD1IaP0&list=PLMcVcytzH5GFZg1mmU2sWTAFvyCKa4EcV", "richard_cooper/before_the_trainwreck"],

    # Sandman (MGTOW videos)
    ["https://www.youtube.com/watch?v=8DmDLB1qHNM&list=PLwwfs0zUhl7THFiyCUkjRoMkz2AB2Yc2e", "sandman/mgtow"],
    ["https://www.youtube.com/watch?v=_qpzcOQE8qI&list=PLwwfs0zUhl7RLr6AqAghsANrs-7BsWFJO", "sandman/prostitution"],
    ["https://www.youtube.com/watch?v=IhljAMQxS6A&list=PLwwfs0zUhl7QXxZQVOrnDZAoZ2mEpOXH7", "sandman/mgtow_movies"],
    ["https://www.youtube.com/watch?v=2hZbQg43nKc&list=PLwwfs0zUhl7Sb77ntGQJIysssNlZkzbjp", "sandman/book_reviews"],
    ["https://www.youtube.com/watch?v=fXbpqLzacZY&list=PLwwfs0zUhl7Qc0OJn22BearDO5Jjgsbok", "sandman/a_god_among_mgtow"],

    ["https://www.youtube.com/channel/UCfpnY5NnBl-8L7SvICuYkYQ/videos", "scott_adams"],
    ["https://www.youtube.com/channel/UCHFqcgpUuyOGSsG5N3_N0sA/videos", "strong_successful_male"],

    ["https://www.youtube.com/watch?v=NHYKpqFUXa0&list=PL3-KFmkeZ60j6iPrvNZxx9_L31KjbrbFE", "tom_leykis"],
    ["https://www.youtube.com/channel/UCWu-IOxbeSD-MRM2Q87ZF0A/videos", "think_before_you_sleep"],
    ["https://www.youtube.com/c/RolloTomassi/videos", "rollo_tomassi"],
    ["https://www.youtube.com/watch?v=430AifBjTsc&list=PLP8MR2_RbLUErFTPy5oI_chngHwid-tQ2", "the_fallen_state"],
    ["https://www.youtube.com/watch?v=mGj_Jm2RrY4&list=PLkVbIsAWN2lvpys3pHlAHXGEamiDEWiRN", "louis_rossman/core_philosophies_and_rants"],
    ["https://www.youtube.com/watch?v=KzOcpheBMDo&list=PLkVbIsAWN2luLeViTZ499dZNsZHavrGBE", "louis_rossman/business_advice"],
    ["https://www.youtube.com/watch?v=P_6vDLq64gE&list=PLkVbIsAWN2ltjJ6bupvWuUoCPv_FDGy5q", "louis_rossman/time_management"],

    # Rekieta Law
    ["https://www.youtube.com/watch?v=LKxyUpyPCFA&list=PLJdwBXWZFqz40DZbE2XAfp3Bp1JOu3oeA", "rekieta_law/livestreams"],
    ["https://www.youtube.com/watch?v=KvWng0jQBcM&list=PLJdwBXWZFqz55XuzYX2RMnOgQWGzIvIaW", "rekieta_law/past_videos"],
    ["https://www.youtube.com/watch?v=YK0NfYE8baQ&list=PLJdwBXWZFqz4B2Y3ZZZsspLrL6o-iONFR", "rekieta_law/ronversations"],
    ["https://www.youtube.com/watch?v=4kLFsicmhMM&list=PLJdwBXWZFqz4OZo9w1lTTToDUYczIBc3Q", "rekieta_law/legal_news"],
    ["https://www.youtube.com/watch?v=S0kiLPUno_8&list=PLJdwBXWZFqz4qhekaRpVbSmh0KrnLKBua", "rekieta_law/drexel_casts"],
    ["https://www.youtube.com/watch?v=snt0KPwYYv0&list=PLJdwBXWZFqz6wcpy4Q9pjXEkpP9WIZI7d", "rekieta_law/weeb_wars_-_vic_mignogna"],
    ["https://www.youtube.com/watch?v=TR6Q5s93ddk&list=PLJdwBXWZFqz6jeXLJfqGCCnMdeFVoD_fg", "rekieta_law/trump_topics"],
    ["https://www.youtube.com/watch?v=EIf51ng0HhE&list=PLJdwBXWZFqz5_7BI6iAA9HHjbc-LuY83D", "rekieta_law/comicsgate"],
    ["https://www.youtube.com/watch?v=tiy2uzWp1LA&list=PLJdwBXWZFqz7htX9VpS_vZP4P6FXDU9n1", "rekieta_law/interviews"],
    ["https://www.youtube.com/watch?v=DN4JCo4bjnM&list=PLJdwBXWZFqz7ZAy84yGaQDThZMu15gg70", "rekieta_law/maddox_vs_dick_masterson_-_the_lolsuit"],
    ["https://www.youtube.com/watch?v=uKa4MKjZNdI&list=PLJdwBXWZFqz6sCGhULUbrXlUVfQSoobNs", "rekieta_law/quarter_pounded"],
    ["https://www.youtube.com/watch?v=B_DqbAlaKd0&list=PLJdwBXWZFqz6XhjKaqrjwwjRBecPwimo-", "rekieta_law/taylor_swift_sued"],
    ["https://www.youtube.com/watch?v=6TgwXIDCl4U&list=PLJdwBXWZFqz6QboVcOKpXpsRAIn9k4oM-", "rekieta_law/gun_control"],
    ["https://www.youtube.com/watch?v=6EofaLD42hE&list=PLJdwBXWZFqz7ECStt50OFTZCZjqa5pss3", "rekieta_law/a_google_manifesto"],

    ["https://www.youtube.com/c/VALUETAINMENT/videos", "valuetainment"],

    ["https://www.youtube.com/c/SaltyCracker/videos", "salty_cracker"],
    ["https://www.youtube.com/c/UncivilLaw/videos", "uncivil_law"],

    ["https://www.youtube.com/c/THEBOYSCASTWITHRYANLONG/videos", "ryan_long/the_boyscast"],

    ["https://www.youtube.com/c/AnthonyBrianLogan/videos", "anthony_brian_logan"],

    ["https://www.youtube.com/channel/UC_YtbwcocB4HbbTRVO8fqbQ/videos", "viking_traveler"],

    ["https://www.youtube.com/c/TheLarryElderShowRadio/videos", "larry_elder_show"],
]

# --format bestvideo
VIDEO = [
    ["https://www.youtube.com/channel/UCZmkvHLQu76lYbW1w9FoGzQ/videos", "larry_elder"],
    ["https://www.youtube.com/c/markdice/videos", "mark_dice"],

    # Prager U
    ["https://www.youtube.com/watch?v=K_yS0X5s0lo&list=PLIBtb_NuIJ1xS4y2x3jS2dpnpuLwokgtS", "prager_u/history"],
    ["https://www.youtube.com/watch?v=qVJAwqxagJs&list=PLIBtb_NuIJ1zF8AdDYs28tR3jfjIwyCpr", "prager_u/bonus_videos"],
    ["https://www.youtube.com/watch?v=yBX-9eUtwzU&list=PLIBtb_NuIJ1w9rrlXRueM3opfoV0rUenS", "prager_u/religion_and_philosophy"],
    ["https://www.youtube.com/watch?v=0X99PQEOk-w&list=PLIBtb_NuIJ1wK13RCWLFaVbzRyrER8wEQ", "prager_u/foreign_affairs"],
    ["https://www.youtube.com/watch?v=SBnyEupyNB8&list=PLIBtb_NuIJ1w9GVrOrzMZbwU7Li6TAT91", "prager_u/life_studies"],
    ["https://www.youtube.com/watch?v=DUyUpkQpMEw&list=PLIBtb_NuIJ1zs1gI2nYdZk6wL606nGOQ9", "prager_u/political_science"],
    ["https://www.youtube.com/watch?v=qZN2jt2cCU4&list=PLIBtb_NuIJ1zpyK6kNR-xPfszMD_uDsEU", "prager_u/environmental_science"],
    ["https://www.youtube.com/watch?v=MpToEILMnA4&list=PLIBtb_NuIJ1w6yO4w6l6uevneVX9qDh7_", "prager_u/race_relations"],
    ["https://www.youtube.com/watch?v=FDwCuz4WUi4&list=PLIBtb_NuIJ1w_5qAEs5cSUJ5Bk0R8QLaY", "prager_u/economics"],
    ["https://www.youtube.com/watch?v=giNJwXiktZ0&list=PLIBtb_NuIJ1zeuQ51NrTz7gMt0q89c8wK", "prager_u/welcome_to_prager_u"],

    ["https://www.youtube.com/watch?v=9cs3f-oI-lI&list=PLkVbIsAWN2lsHdY7ldAAgtJug50pRNQv0", "louis_rossman/macbook_component_level_logic_board_repairs"],
    ["https://www.youtube.com/watch?v=D2u1zPgphiM&list=PLkVbIsAWN2ltOWmriIdOc5CtiZqUTH7GT", "louis_rossman/guide_to_basic_electronics"],

    # red letter media
    ["https://www.youtube.com/watch?v=UCIYCaXNe88&list=PLJ_TJFLc25JRrUJFPO6Iwy2vkn8QtqBCE", "red_letter_media/nerd_crew"],
    ["https://www.youtube.com/watch?v=1sJM0_xyO1c&list=PLJ_TJFLc25JSpxBDbSYnlyjHlg0YIp2ZX", "red_letter_media/movie_talk"],
    ["https://www.youtube.com/watch?v=N-px3CZv0zI&list=PLJ_TJFLc25JSmtBkyIYqgD5KabbU57yzY", "red_letter_media/re_view"],
    ["https://www.youtube.com/watch?v=MiqElS_RfPw&list=PLJ_TJFLc25JTxhK8VHJXHAG7QMiUd-JXd", "red_letter_media/highlights"],
    ["https://www.youtube.com/watch?v=Mtr9_BD7UZo&list=PLJ_TJFLc25JTq_lP-ajxB3OQJnDsK9M0-", "red_letter_media/pre_rec"],
    ["https://www.youtube.com/watch?v=Ao99bNrJ_1Q&list=PLJ_TJFLc25JQaIKha3sduCHUXkFcNMMDS", "red_letter_media/mr_plinkett_ads_and_trailers"],
    ["https://www.youtube.com/watch?v=pF28Zednl10&list=PLJ_TJFLc25JSeHaHvnLsVJjpPGbFsylAE", "red_letter_media/behind_the_scenes"],
    ["https://www.youtube.com/watch?v=DXWTfamqgMg&list=PLJ_TJFLc25JR3VZ7Xe-cmt4k3bMKBZ5Tm", "red_letter_media/best_of_the_worst"],
    ["https://www.youtube.com/watch?v=svzfjasdvac&list=PL8F9A69893481FB47", "red_letter_media/shorts_and_weird_stuff"],
    ["https://www.youtube.com/watch?v=3tx33tgXT3M&list=PL34C1F26D03F5F9B8", "red_letter_media/half_in_the_bag"],
    ["https://www.youtube.com/watch?v=FxKtZmQgxrI&list=PL5919C8DE6F720A2D", "red_letter_media/star_wars_episode_1"],
    ["https://www.youtube.com/watch?v=KPt1am18lR4&list=PL56E3EB1DFD4B64A2", "red_letter_media/star_wars_episode_2"],
    ["https://www.youtube.com/watch?v=bYWAHuFbLoc&list=PLJ_TJFLc25JTwinvdLo4PP2rTFfTd9Uhz", "red_letter_media/star_wars_episode_3"],

    ["https://www.youtube.com/watch?v=oikBLnA076k&list=PLYLi1xsyfNshKtpc0Czo-Oig0qDYnrS0H", "ryan_long/ryan_long_is_challenged"],
    ["https://www.youtube.com/watch?v=yPtYd7TzKDQ&list=PLYLi1xsyfNsi4sJX1RY6fTRBZqaUEV_w5", "ryan_long/sketches"],
    ["https://www.youtube.com/watch?v=3SO9F7EuXn4&list=PLYLi1xsyfNsgpYyEAgEq-wmhdywKNxwHy", "ryan_long/on_the_street"],
]
