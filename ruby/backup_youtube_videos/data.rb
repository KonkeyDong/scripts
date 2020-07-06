#!/usr/bin/ruby

# Array format:
#   [0] = youtube url
#   [1] = directory name

# --format bestaudio
AUDIO = [
    ["https://www.youtube.com/user/AaronClarey/videos", "aaron_clarey"],
    ["https://www.youtube.com/user/artofmanliness/videos", "art_of_manliness"],
    ["https://www.youtube.com/channel/UC5tEELgWBfKbA9fVPRzBzPQ/videos", "coach_red_pill"],
    ["https://www.youtube.com/watch?v=T5yyHZwTOpA&list=PLIBtb_NuIJ1wCrBmN2Z3jcQ4vvmOEi-7-", "prager_u/fireside_chat"],
    ["https://www.youtube.com/watch?v=TJFhZIjTIhU&list=PL68d6MdnLpLs4HVxM5npoRzidNlMgZn_a", "george_bruno/daybreak_show"],
    ["https://www.youtube.com/watch?v=L6dQH0CT3B8&list=PL7ukuCEjUSlxLH3WbxnlG8MlahVoPpfbz", "HuMAN"],
    ["https://www.youtube.com/channel/UCfpnY5NnBl-8L7SvICuYkYQ/videos", "scott_adams"],
    ["https://www.youtube.com/channel/UC-tLyAaPbRZiYrOJxAGB7dQ/videos", "pursuit_of_wonder"],

    # Better Bachelor / Odd Man Out
    ["https://www.youtube.com/channel/UC9ctsJZ2aD1nCexfqj342NQ/videos", "better_bachelor"],
    ["https://www.youtube.com/channel/UC7JGB6SrWxxeU33FHvffBBg/videos", "better_bachelor/odd_man_out"],

    # Richard Cooper (Entrepreneurs in Cars)
    ["https://www.youtube.com/watch?v=560SL5e3lQ8&list=PLMcVcytzH5GGM8e1RT72urO1HY17i8fqT", "richard_cooper/playing_to_win"],
    ["https://www.youtube.com/watch?v=ImjUfM5lli8&list=PLMcVcytzH5GHS5AtBy6YZqdHdO3sn3P0L", "richard_cooper/mens_dating_advice"],
    ["https://www.youtube.com/watch?v=n1JoMsDJqgw&list=PLMcVcytzH5GEkYN7-aGRMikLCbZ8YzSY2", "richard_cooper/money_advice"],
    ["https://www.youtube.com/watch?v=no7QSlMOrYc&list=PLMcVcytzH5GEZRHeDCeHPDY2HMeoNsS9n", "richard_cooper/self_care"],
    ["https://www.youtube.com/watch?v=O2KmvuzaCQ8&list=PLMcVcytzH5GFfyjstvv4G5rezVKc6tziI", "richard_cooper/entrepreneurial_and_bsuiness_tips"],
    ["https://www.youtube.com/watch?v=6jPh1oiOzAM&list=PLMcVcytzH5GHH2YMfJ1qcAZ2cMyBwtpjK", "richard_cooper/marriage"],
    ["https://www.youtube.com/watch?v=eQFNpD1IaP0&list=PLMcVcytzH5GFZg1mmU2sWTAFvyCKa4EcV", "richard_cooper/before_the_trainwreck"],

    ["https://www.youtube.com/watch?v=NHYKpqFUXa0&list=PL3-KFmkeZ60j6iPrvNZxx9_L31KjbrbFE", "tom_leykis"],
    ["https://www.youtube.com/channel/UCWu-IOxbeSD-MRM2Q87ZF0A/videos", "think_before_you_sleep"],

    # Sandman (MGTOW videos)
    ["https://www.youtube.com/watch?v=8DmDLB1qHNM&list=PLwwfs0zUhl7THFiyCUkjRoMkz2AB2Yc2e", "sandman/mgtow"],
    ["https://www.youtube.com/watch?v=_qpzcOQE8qI&list=PLwwfs0zUhl7RLr6AqAghsANrs-7BsWFJO", "sandman/prostitution"],
    ["https://www.youtube.com/watch?v=IhljAMQxS6A&list=PLwwfs0zUhl7QXxZQVOrnDZAoZ2mEpOXH7", "sandman/mgtow_movies"],
    ["https://www.youtube.com/watch?v=2hZbQg43nKc&list=PLwwfs0zUhl7Sb77ntGQJIysssNlZkzbjp", "sandman/book_reviews"],
    ["https://www.youtube.com/watch?v=fXbpqLzacZY&list=PLwwfs0zUhl7Qc0OJn22BearDO5Jjgsbok", "sandman/a_god_among_mgtow"],
    ["https://www.youtube.com/watch?v=fXbpqLzacZY&list=PLwwfs0zUhl7Qc0OJn22BearDO5Jjgsbok", "sandman/a_god_among_mgtow"],

    # Better Ideas
    ["https://www.youtube.com/channel/UCtUId5WFnN82GdDy7DgaQ7w/videos", "better_ideas"],

    ["https://www.youtube.com/channel/UCc7-Rr-wSO530znK2ny05JQ/videos", "donovan_sharpe"],
    ["https://www.youtube.com/channel/UCHFqcgpUuyOGSsG5N3_N0sA/videos", "strong_successful_male"],

]

# --format bestvideo
VIDEO = [
    ["https://www.youtube.com/channel/UCZmkvHLQu76lYbW1w9FoGzQ/videos", "larry_elder"],

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
    ["https://www.youtube.com/c/markdice/videos", "mark_dice"],
]

