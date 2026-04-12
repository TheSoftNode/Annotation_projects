cgit logo index : grep.git

                      master

                          grep
                              summaryrefslogtreecommitdiff

                                  log msg

                                      path : root /
    src / grep.c blob : 6fd6163c89ebfa9716b0ae226f2358f1e0a6265a(plain)1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 471 472 473 474 475 476 477 478 479 480 481 482 483 484 485 486 487 488 489 490 491 492 493 494 495 496 497 498 499 500 501 502 503 504 505 506 507 508 509 510 511 512 513 514 515 516 517 518 519 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 539 540 541 542 543 544 545 546 547 548 549 550 551 552 553 554 555 556 557 558 559 560 561 562 563 564 565 566 567 568 569 570 571 572 573 574 575 576 577 578 579 580 581 582 583 584 585 586 587 588 589 590 591 592 593 594 595 596 597 598 599 600 601 602 603 604 605 606 607 608 609 610 611 612 613 614 615 616 617 618 619 620 621 622 623 624 625 626 627 628 629 630 631 632 633 634 635 636 637 638 639 640 641 642 643 644 645 646 647 648 649 650 651 652 653 654 655 656 657 658 659 660 661 662 663 664 665 666 667 668 669 670 671 672 673 674 675 676 677 678 679 680 681 682 683 684 685 686 687 688 689 690 691 692 693 694 695 696 697 698 699 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 717 718 719 720 721 722 723 724 725 726 727 728 729 730 731 732 733 734 735 736 737 738 739 740 741 742 743 744 745 746 747 748 749 750 751 752 753 754 755 756 757 758 759 760 761 762 763 764 765 766 767 768 769 770 771 772 773 774 775 776 777 778 779 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 800 801 802 803 804 805 806 807 808 809 810 811 812 813 814 815 816 817 818 819 820 821 822 823 824 825 826 827 828 829 830 831 832 833 834 835 836 837 838 839 840 841 842 843 844 845 846 847 848 849 850 851 852 853 854 855 856 857 858 859 860 861 862 863 864 865 866 867 868 869 870 871 872 873 874 875 876 877 878 879 880 881 882 883 884 885 886 887 888 889 890 891 892 893 894 895 896 897 898 899 900 901 902 903 904 905 906 907 908 909 910 911 912 913 914 915 916 917 918 919 920 921 922 923 924 925 926 927 928 929 930 931 932 933 934 935 936 937 938 939 940 941 942 943 944 945 946 947 948 949 950 951 952 953 954 955 956 957 958 959 960 961 962 963 964 965 966 967 968 969 970 971 972 973 974 975 976 977 978 979 980 981 982 983 984 985 986 987 988 989 990 991 992 993 994 995 996 997 998 999 1000 1001 1002 1003 1004 1005 1006 1007 1008 1009 1010 1011 1012 1013 1014 1015 1016 1017 1018 1019 1020 1021 1022 1023 1024 1025 1026 1027 1028 1029 1030 1031 1032 1033 1034 1035 1036 1037 1038 1039 1040 1041 1042 1043 1044 1045 1046 1047 1048 1049 1050 1051 1052 1053 1054 1055 1056 1057 1058 1059 1060 1061 1062 1063 1064 1065 1066 1067 1068 1069 1070 1071 1072 1073 1074 1075 1076 1077 1078 1079 1080 1081 1082 1083 1084 1085 1086 1087 1088 1089 1090 1091 1092 1093 1094 1095 1096 1097 1098 1099 1100 1101 1102 1103 1104 1105 1106 1107 1108 1109 1110 1111 1112 1113 1114 1115 1116 1117 1118 1119 1120 1121 1122 1123 1124 1125 1126 1127 1128 1129 1130 1131 1132 1133 1134 1135 1136 1137 1138 1139 1140 1141 1142 1143 1144 1145 1146 1147 1148 1149 1150 1151 1152 1153 1154 1155 1156 1157 1158 1159 1160 1161 1162 1163 1164 1165 1166 1167 1168 1169 1170 1171 1172 1173 1174 1175 1176 1177 1178 1179 1180 1181 1182 1183 1184 1185 1186 1187 1188 1189 1190 1191 1192 1193 1194 1195 1196 1197 1198 1199 1200 1201 1202 1203 1204 1205 1206 1207 1208 1209 1210 1211 1212 1213 1214 1215 1216 1217 1218 1219 1220 1221 1222 1223 1224 1225 1226 1227 1228 1229 1230 1231 1232 1233 1234 1235 1236 1237 1238 1239 1240 1241 1242 1243 1244 1245 1246 1247 1248 1249 1250 1251 1252 1253 1254 1255 1256 1257 1258 1259 1260 1261 1262 1263 1264 1265 1266 1267 1268 1269 1270 1271 1272 1273 1274 1275 1276 1277 1278 1279 1280 1281 1282 1283 1284 1285 1286 1287 1288 1289 1290 1291 1292 1293 1294 1295 1296 1297 1298 1299 1300 1301 1302 1303 1304 1305 1306 1307 1308 1309 1310 1311 1312 1313 1314 1315 1316 1317 1318 1319 1320 1321 1322 1323 1324 1325 1326 1327 1328 1329 1330 1331 1332 1333 1334 1335 1336 1337 1338 1339 1340 1341 1342 1343 1344 1345 1346 1347 1348 1349 1350 1351 1352 1353 1354 1355 1356 1357 1358 1359 1360 1361 1362 1363 1364 1365 1366 1367 1368 1369 1370 1371 1372 1373 1374 1375 1376 1377 1378 1379 1380 1381 1382 1383 1384 1385 1386 1387 1388 1389 1390 1391 1392 1393 1394 1395 1396 1397 1398 1399 1400 1401 1402 1403 1404 1405 1406 1407 1408 1409 1410 1411 1412 1413 1414 1415 1416 1417 1418 1419 1420 1421 1422 1423 1424 1425 1426 1427 1428 1429 1430 1431 1432 1433 1434 1435 1436 1437 1438 1439 1440 1441 1442 1443 1444 1445 1446 1447 1448 1449 1450 1451 1452 1453 1454 1455 1456 1457 1458 1459 1460 1461 1462 1463 1464 1465 1466 1467 1468 1469 1470 1471 1472 1473 1474 1475 1476 1477 1478 1479 1480 1481 1482 1483 1484 1485 1486 1487 1488 1489 1490 1491 1492 1493 1494 1495 1496 1497 1498 1499 1500 1501 1502 1503 1504 1505 1506 1507 1508 1509 1510 1511 1512 1513 1514 1515 1516 1517 1518 1519 1520 1521 1522 1523 1524 1525 1526 1527 1528 1529 1530 1531 1532 1533 1534 1535 1536 1537 1538 1539 1540 1541 1542 1543 1544 1545 1546 1547 1548 1549 1550 1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567 1568 1569 1570 1571 1572 1573 1574 1575 1576 1577 1578 1579 1580 1581 1582 1583 1584 1585 1586 1587 1588 1589 1590 1591 1592 1593 1594 1595 1596 1597 1598 1599 1600 1601 1602 1603 1604 1605 1606 1607 1608 1609 1610 1611 1612 1613 1614 1615 1616 1617 1618 1619 1620 1621 1622 1623 1624 1625 1626 1627 1628 1629 1630 1631 1632 1633 1634 1635 1636 1637 1638 1639 1640 1641 1642 1643 1644 1645 1646 1647 1648 1649 1650 1651 1652 1653 1654 1655 1656 1657 1658 1659 1660 1661 1662 1663 1664 1665 1666 1667 1668 1669 1670 1671 1672 1673 1674 1675 1676 1677 1678 1679 1680 1681 1682 1683 1684 1685 1686 1687 1688 1689 1690 1691 1692 1693 1694 1695 1696 1697 1698 1699 1700 1701 1702 1703 1704 1705 1706 1707 1708 1709 1710 1711 1712 1713 1714 1715 1716 1717 1718 1719 1720 1721 1722 1723 1724 1725 1726 1727 1728 1729 1730 1731 1732 1733 1734 1735 1736 1737 1738 1739 1740 1741 1742 1743 1744 1745 1746 1747 1748 1749 1750 1751 1752 1753 1754 1755 1756 1757 1758 1759 1760 1761 1762 1763 1764 1765 1766 1767 1768 1769 1770 1771 1772 1773 1774 1775 1776 1777 1778 1779 1780 1781 1782 1783 1784 1785 1786 1787 1788 1789 1790 1791 1792 1793 1794 1795 1796 1797 1798 1799 1800 1801 1802 1803 1804 1805 1806 1807 1808 1809 1810 1811 1812 1813 1814 1815 1816 1817 1818 1819 1820 1821 1822 1823 1824 1825 1826 1827 1828 1829 1830 1831 1832 1833 1834 1835 1836 1837 1838 1839 1840 1841 1842 1843 1844 1845 1846 1847 1848 1849 1850 1851 1852 1853 1854 1855 1856 1857 1858 1859 1860 1861 1862 1863 1864 1865 1866 1867 1868 1869 1870 1871 1872 1873 1874 1875 1876 1877 1878 1879 1880 1881 1882 1883 1884 1885 1886 1887 1888 1889 1890 1891 1892 1893 1894 1895 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 1931 1932 1933 1934 1935 1936 1937 1938 1939 1940 1941 1942 1943 1944 1945 1946 1947 1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 1958 1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030 2031 2032 2033 2034 2035 2036 2037 2038 2039 2040 2041 2042 2043 2044 2045 2046 2047 2048 2049 2050 2051 2052 2053 2054 2055 2056 2057 2058 2059 2060 2061 2062 2063 2064 2065 2066 2067 2068 2069 2070 2071 2072 2073 2074 2075 2076 2077 2078 2079 2080 2081 2082 2083 2084 2085 2086 2087 2088 2089 2090 2091 2092 2093 2094 2095 2096 2097 2098 2099 2100 2101 2102 2103 2104 2105 2106 2107 2108 2109 2110 2111 2112 2113 2114 2115 2116 2117 2118 2119 2120 2121 2122 2123 2124 2125 2126 2127 2128 2129 2130 2131 2132 2133 2134 2135 2136 2137 2138 2139 2140 2141 2142 2143 2144 2145 2146 2147 2148 2149 2150 2151 2152 2153 2154 2155 2156 2157 2158 2159 2160 2161 2162 2163 2164 2165 2166 2167 2168 2169 2170 2171 2172 2173 2174 2175 2176 2177 2178 2179 2180 2181 2182 2183 2184 2185 2186 2187 2188 2189 2190 2191 2192 2193 2194 2195 2196 2197 2198 2199 2200 2201 2202 2203 2204 2205 2206 2207 2208 2209 2210 2211 2212 2213 2214 2215 2216 2217 2218 2219 2220 2221 2222 2223 2224 2225 2226 2227 2228 2229 2230 2231 2232 2233 2234 2235 2236 2237 2238 2239 2240 2241 2242 2243 2244 2245 2246 2247 2248 2249 2250 2251 2252 2253 2254 2255 2256 2257 2258 2259 2260 2261 2262 2263 2264 2265 2266 2267 2268 2269 2270 2271 2272 2273 2274 2275 2276 2277 2278 2279 2280 2281 2282 2283 2284 2285 2286 2287 2288 2289 2290 2291 2292 2293 2294 2295 2296 2297 2298 2299 2300 2301 2302 2303 2304 2305 2306 2307 2308 2309 2310 2311 2312 2313 2314 2315 2316 2317 2318 2319 2320 2321 2322 2323 2324 2325 2326 2327 2328 2329 2330 2331 2332 2333 2334 2335 2336 2337 2338 2339 2340 2341 2342 2343 2344 2345 2346 2347 2348 2349 2350 2351 2352 2353 2354 2355 2356 2357 2358 2359 2360 2361 2362 2363 2364 2365 2366 2367 2368 2369 2370 2371 2372 2373 2374 2375 2376 2377 2378 2379 2380 2381 2382 2383 2384 2385 2386 2387 2388 2389 2390 2391 2392 2393 2394 2395 2396 2397 2398 2399 2400 2401 2402 2403 2404 2405 2406 2407 2408 2409 2410 2411 2412 2413 2414 2415 2416 2417 2418 2419 2420 2421 2422 2423 2424 2425 2426 2427 2428 2429 2430 2431 2432 2433 2434 2435 2436 2437 2438 2439 2440 2441 2442 2443 2444 2445 2446 2447 2448 2449 2450 2451 2452 2453 2454 2455 2456 2457 2458 2459 2460 2461 2462 2463 2464 2465 2466 2467 2468 2469 2470 2471 2472 2473 2474 2475 2476 2477 2478 2479 2480 2481 2482 2483 2484 2485 2486 2487 2488 2489 2490 2491 2492 2493 2494 2495 2496 2497 2498 2499 2500 2501 2502 2503 2504 2505 2506 2507 2508 2509 2510 2511 2512 2513 2514 2515 2516 2517 2518 2519 2520 2521 2522 2523 2524 2525 2526 2527 2528 2529 2530 2531 2532 2533 2534 2535 2536 2537 2538 2539 2540 2541 2542 2543 2544 2545 2546 2547 2548 2549 2550 2551 2552 2553 2554 2555 2556 2557 2558 2559 2560 2561 2562 2563 2564 2565 2566 2567 2568 2569 2570 2571 2572 2573 2574 2575 2576 2577 2578 2579 2580 2581 2582 2583 2584 2585 2586 2587 2588 2589 2590 2591 2592 2593 2594 2595 2596 2597 2598 2599 2600 2601 2602 2603 2604 2605 2606 2607 2608 2609 2610 2611 2612 2613 2614 2615 2616 2617 2618 2619 2620 2621 2622 2623 2624 2625 2626 2627 2628 2629 2630 2631 2632 2633 2634 2635 2636 2637 2638 2639 2640 2641 2642 2643 2644 2645 2646 2647 2648 2649 2650 2651 2652 2653 2654 2655 2656 2657 2658 2659 2660 2661 2662 2663 2664 2665 2666 2667 2668 2669 2670 2671 2672 2673 2674 2675 2676 2677 2678 2679 2680 2681 2682 2683 2684 2685 2686 2687 2688 2689 2690 2691 2692 2693 2694 2695 2696 2697 2698 2699 2700 2701 2702 2703 2704 2705 2706 2707 2708 2709 2710 2711 2712 2713 2714 2715 2716 2717 2718 2719 2720 2721 2722 2723 2724 2725 2726 2727 2728 2729 2730 2731 2732 2733 2734 2735 2736 2737 2738 2739 2740 2741 2742 2743 2744 2745 2746 2747 2748 2749 2750 2751 2752 2753 2754 2755 2756 2757 2758 2759 2760 2761 2762 2763 2764 2765 2766 2767 2768 2769 2770 2771 2772 2773 2774 2775 2776 2777 2778 2779 2780 2781 2782 2783 2784 2785 2786 2787 2788 2789 2790 2791 2792 2793 2794 2795 2796 2797 2798 2799 2800 2801 2802 2803 2804 2805 2806 2807 2808 2809 2810 2811 2812 2813 2814 2815 2816 2817 2818 2819 2820 2821 2822 2823 2824 2825 2826 2827 2828 2829 2830 2831 2832 2833 2834 2835 2836 2837 2838 2839 2840 2841 2842 2843 2844 2845 2846 2847 2848 2849 2850 2851 2852 2853 2854 2855 2856 2857 2858 2859 2860 2861 2862 2863 2864 2865 2866 2867 2868 2869 2870 2871 2872 2873 2874 2875 2876 2877 2878 2879 2880 2881 2882 2883 2884 2885 2886 2887 2888 2889 2890 2891 2892 2893 2894 2895 2896 2897 2898 2899 2900 2901 2902 2903 2904 2905 2906 2907 2908 2909 2910 2911 2912 2913 2914 2915 2916 2917 2918 2919 2920 2921 2922 2923 2924 2925 2926 2927 2928 2929 2930 2931 2932 2933 2934 2935 2936 2937 2938 2939 2940 2941 2942 2943 2944 2945 2946 2947 2948 2949 2950 2951 2952 2953 2954 2955 2956 2957 2958 2959 2960 2961 2962 2963 2964 2965 2966 2967 2968 2969 2970 2971 2972 2973 2974 2975 2976 2977 2978 2979 2980 2981 2982 2983 2984 2985 2986 2987 2988 2989 2990 2991 2992 2993 2994 2995 2996 2997 2998 2999 3000 3001 3002 3003 3004 3005 3006 3007 3008 3009 3010 3011 3012 3013 3014 3015 3016 3017 3018 3019 3020 3021 3022 3023 3024 3025 3026 3027 3028 3029 3030 3031 3032 3033 3034 3035 3036

/\* grep.c - main driver file for grep.
Copyright (C) 1992, 1997-2002, 2004-2026 Free Software Foundation, Inc.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>. \*/

/_ Written July 1992 by Mike Haertel. _/

#include <config.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <uchar.h>
#include <wchar.h>
#include <inttypes.h>
#include <stdarg.h>
#include <stdckdint.h>
#include <stdint.h>
#include <stdio.h>
#include "system.h"

#include "argmatch.h"
#include "c-ctype.h"
#include "c-stack.h"
#include "closeout.h"
#include "colorize.h"
#include "die.h"
#include <error.h>
#include "exclude.h"
#include "exitfail.h"
#include "fcntl-safer.h"
#include "fts\_.h"
#include <getopt.h>
#include "grep.h"
#include "hash.h"
#include "intprops.h"
#include "safe-read.h"
#include <search.h>
#include "c-strcase.h"
#include "version-etc.h"
#include "xalloc.h"
#include "xbinary-io.h"
#include "xstrtol.h"

          enum { SEP_CHAR_SELECTED = ':' };

enum
{
SEP_CHAR_REJECTED = '-'
};
static char const SEP_STR_GROUP[] = "--";

/_ When stdout is connected to a regular file, save its stat
information here, so that we can automatically skip it, thus
avoiding a potential (racy) infinite loop. _/
static struct stat out_stat;

/_ if non-zero, display usage information and exit _/
static int show_help;

/_ Print the version on standard output and exit. _/
static bool show_version;

/_ Suppress diagnostics for nonexistent or unreadable files. _/
static bool suppress_errors;

/_ If nonzero, use color markers. _/
static int color_option;

/_ Show only the part of a line matching the expression. _/
static bool only_matching;

/_ If nonzero, make sure first content char in a line is on a tab stop. _/
static bool align_tabs;

/_ Print width of line numbers and byte offsets. Nonzero if ALIGN_TABS. _/
static int offset_width;

/_ An entry in the PATLOC array saying where patterns came from. _/
struct patloc
{
/_ Line number of the pattern in PATTERN_ARRAY. Line numbers
start at 0, and each pattern is terminated by '\n'. _/
idx_t lineno;

    /* Input location of the pattern.  The FILENAME "-" represents
       standard input, and "" represents the command line.  FILELINE is
       origin-1 for files and is irrelevant for the command line.  */
    char const *filename;
    idx_t fileline;

};

/_ The array of pattern locations. The concatenation of all patterns
is stored in a single array, KEYS. Given the invocation
'grep -f <(seq 5) -f <(seq 6) -f <(seq 3)', there will initially be
28 bytes in KEYS. After duplicate patterns are removed, KEYS
will have 12 bytes and PATLOC will be {0,x,1}, {10,y,1}
where x, y and z are just place-holders for shell-generated names
since and z is omitted as it contains only duplicates. Sometimes
removing duplicates will grow PATLOC, since each run of
removed patterns not at a file start or end requires another
PATLOC entry for the first non-removed pattern. _/
static struct patloc \*patloc;
static idx_t patlocs_allocated, patlocs_used;

/_ Pointer to the array of patterns, each terminated by newline. _/
static char \*pattern_array;

/_ The number of unique patterns seen so far. _/
static idx_t n_patterns;

/_ Hash table of patterns seen so far. _/
static Hash_table \*pattern_table;

/_ Hash and compare newline-terminated patterns for textual equality.
Patterns are represented by origin-1 offsets into PATTERN_ARRAY,
cast to void _. The origin-1 is so that the first pattern offset
does not appear to be a null pointer when cast to void _. _/
static size_t \_GL_ATTRIBUTE_PURE
hash_pattern(void const _pat, size_t n_buckets)
{
/_ This uses the djb2 algorithm, except starting with a larger prime
in place of djb2's 5381, if size_t is wide enough. The primes
are taken from the primeth recurrence sequence
<https://oeis.org/A007097>. h15, h32 and h64 are the largest
sequence members that fit into 15, 32 and 64 bits, respectively.
Since any H will do, hashing works correctly on oddball machines
where size_t has some other width. */
uint_fast64_t h15 = 5381, h32 = 3657500101, h64 = 4123221751654370051;
size_t h = h64 <= SIZE_MAX ? h64 : h32 <= SIZE_MAX ? h32
: h15;
intptr_t pat_offset = (intptr_t)pat - 1;
unsigned char const *s = (unsigned char const *)pattern_array + pat_offset;
for (; *s != '\n'; s++)
h = h * 33 ^ *s;
return h % n_buckets;
}
static bool \_GL_ATTRIBUTE_PURE
compare_patterns(void const *a, void const *b)
{
intptr_t a_offset = (intptr_t)a - 1;
intptr_t b_offset = (intptr_t)b - 1;
char const *p = pattern_array + a_offset;
char const *q = pattern_array + b_offset;
for (; *p == *q; p++, q++)
if (\*p == '\n')
return true;
return false;
}

/_ Update KEYS to remove duplicate patterns, and return the number of
bytes in the resulting KEYS. KEYS contains a sequence of patterns
each terminated by '\n'. The first DUPFREE_SIZE bytes are a
sequence of patterns with no duplicates; SIZE is the total number
of bytes in KEYS. If some patterns past the first DUPFREE_SIZE
bytes are not duplicates, update PATLOCS accordingly. _/
static idx_t
update_patterns(char *keys, idx_t dupfree_size, idx_t size,
char const *filename)
{
char \*dst = keys + dupfree_size;
idx_t fileline = 1;
int prev_inserted = 0;

    char const *srclim = keys + size;
    idx_t patsize;
    for (char const *src = keys + dupfree_size; src < srclim; src += patsize)
    {
        char const *patend = rawmemchr(src, '\n');
        patsize = patend + 1 - src;
        memmove(dst, src, patsize);

        intptr_t dst_offset_1 = dst - keys + 1;
        int inserted = hash_insert_if_absent(pattern_table,
                                             (void *)dst_offset_1, nullptr);
        if (inserted)
        {
            if (inserted < 0)
                xalloc_die();
            dst += patsize;

            /* Add a PATLOCS entry unless this input line is simply the
               next one in the same file.  */
            if (!prev_inserted)
            {
                if (patlocs_used == patlocs_allocated)
                    patloc = xpalloc(patloc, &patlocs_allocated, 1, -1,
                                     sizeof *patloc);
                patloc[patlocs_used++] = (struct patloc){.lineno = n_patterns,
                                                         .filename = filename,
                                                         .fileline = fileline};
            }
            n_patterns++;
        }

        prev_inserted = inserted;
        fileline++;
    }

    return dst - keys;

}

/* Map LINENO, the origin-0 line number of one of the input patterns,
to the name of the file from which it came. Return "-" if it was
read from stdin, "" if it was specified on the command line.
Set *NEW_LINENO to the origin-1 line number of PATTERN in the file,
or to an unspecified value if PATTERN came from the command line. _/
char const _\_GL_ATTRIBUTE_PURE
pattern_file_name(idx_t lineno, idx_t *new_lineno)
{
idx_t i;
for (i = 1; i < patlocs_used; i++)
if (lineno < patloc[i].lineno)
break;
*new_lineno = lineno - patloc[i - 1].lineno + patloc[i - 1].fileline;
return patloc[i - 1].filename;
}

#if HAVE_ASAN
/_ Record the starting address and length of the sole poisoned region,
so that we can unpoison it later, just before each following read. _/
static void const \*poison_buf;
static idx_t poison_len;

static void
clear_asan_poison(void)
{
if (poison_buf)
\_\_asan_unpoison_memory_region(poison_buf, poison_len);
}

static void
asan_poison(void const \*addr, idx_t size)
{
poison_buf = addr;
poison_len = size;

    __asan_poison_memory_region(poison_buf, poison_len);

}
#else
static void clear_asan_poison(void) {}
static void asan_poison(void const volatile \*addr, idx_t size) {}
#endif

/_ The group separator used when context is requested. _/
static const char \*group_separator = SEP_STR_GROUP;

/_ The context and logic for choosing default --color screen attributes
(foreground and background colors, etc.) are the following.
-- There are eight basic colors available, each with its own
nominal luminosity to the human eye and foreground/background
codes (black [0 %, 30/40], blue [11 %, 34/44], red [30 %, 31/41],
magenta [41 %, 35/45], green [59 %, 32/42], cyan [70 %, 36/46],
yellow [89 %, 33/43], and white [100 %, 37/47]).
-- Sometimes, white as a background is actually implemented using
a shade of light gray, so that a foreground white can be visible
on top of it (but most often not).
-- Sometimes, black as a foreground is actually implemented using
a shade of dark gray, so that it can be visible on top of a
background black (but most often not).
-- Sometimes, more colors are available, as extensions.
-- Other attributes can be selected/deselected (bold [1/22],
underline [4/24], standout/inverse [7/27], blink [5/25], and
invisible/hidden [8/28]). They are sometimes implemented by
using colors instead of what their names imply; e.g., bold is
often achieved by using brighter colors. In practice, only bold
is really available to us, underline sometimes being mapped by
the terminal to some strange color choice, and standout best
being left for use by downstream programs such as less(1).
-- We cannot assume that any of the extensions or special features
are available for the purpose of choosing defaults for everyone.
-- The most prevalent default terminal backgrounds are pure black
and pure white, and are not necessarily the same shades of
those as if they were selected explicitly with SGR sequences.
Some terminals use dark or light pictures as default background,
but those are covered over by an explicit selection of background
color with an SGR sequence; their users will appreciate their
background pictures not be covered like this, if possible.
-- Some uses of colors attributes is to make some output items
more understated (e.g., context lines); this cannot be achieved
by changing the background color.
-- For these reasons, the grep color defaults should strive not
to change the background color from its default, unless it's
for a short item that should be highlighted, not understated.
-- The grep foreground color defaults (without an explicitly set
background) should provide enough contrast to be readable on any
terminal with either a black (dark) or white (light) background.
This only leaves red, magenta, green, and cyan (and their bold
counterparts) and possibly bold blue. _/
/_ The color strings used for matched text.
The user can overwrite them using the GREP_COLORS environment variable. _/
static const char _selected_match_color = "01;31"; /_ bold red */
static const char *context_match_color = "01;31"; /_ bold red _/

/_ Other colors. Defaults look damn good. _/
static const char _filename_color = "35"; /_ magenta */
static const char *line_num_color = "32"; /_ green _/
static const char _byte_num_color = "32"; /_ green */
static const char *sep_color = "36"; /_ cyan _/
static const char _selected_line_color = ""; /_ default color pair */
static const char *context_line_color = ""; /_ default color pair _/

/_ Select Graphic Rendition (SGR, "\33[...m") strings. _/
/_ Also Erase in Line (EL) to Right ("\33[K") by default. _/
/\* Why have EL to Right after SGR?
-- The behavior of line-wrapping when at the bottom of the
terminal screen and at the end of the current line is often
such that a new line is introduced, entirely cleared with
the current background color which may be different from the
default one (see the boolean back_color_erase terminfo(5)
capability), thus scrolling the display by one line.
The end of this new line will stay in this background color
even after reverting to the default background color with
"\33[m', unless it is explicitly cleared again with "\33[K"
(which is the behavior the user would instinctively expect
from the whole thing). There may be some unavoidable
background-color flicker at the end of this new line because
of this (when timing with the monitor's redraw is just right).
-- The behavior of HT (tab, "\t") is usually the same as that of
Cursor Forward Tabulation (CHT) with a default parameter
of 1 ("\33[I"), i.e., it performs pure movement to the next
tab stop, without any clearing of either content or screen
attributes (including background color); try
printf 'asdfqwerzxcv\rASDF\tZXCV\n'
in a bash(1) shell to demonstrate this. This is not what the
user would instinctively expect of HT (but is ok for CHT).
The instinctive behavior would include clearing the terminal
cells that are skipped over by HT with blank cells in the
current screen attributes, including background color;
the boolean dest_tabs_magic_smso terminfo(5) capability
indicates this saner behavior for HT, but only some rare
terminals have it (although it also indicates a special
glitch with standout mode in the Teleray terminal for which
it was initially introduced). The remedy is to add "\33K"
after each SGR sequence, be it START (to fix the behavior
of any HT after that before another SGR) or END (to fix the
behavior of an HT in default background color that would
follow a line-wrapping at the bottom of the screen in another
background color, and to complement doing it after START).
Piping grep's output through a pager such as less(1) avoids
any HT problems since the pager performs tab expansion.

      Generic disadvantages of this remedy are:
         -- Some very rare terminals might support SGR but not EL (nobody
            will use "grep --color" on a terminal that does not support
            SGR in the first place).
         -- Having these extra control sequences might somewhat complicate
            the task of any program trying to parse "grep --color"
            output in order to extract structuring information from it.
      A specific disadvantage to doing it after SGR START is:
         -- Even more possible background color flicker (when timing
            with the monitor's redraw is just right), even when not at the
            bottom of the screen.
      There are no additional disadvantages specific to doing it after
      SGR END.

      It would be impractical for GNU grep to become a full-fledged
      terminal program linked against ncurses or the like, so it will
      not detect terminfo(5) capabilities.  */

static const char *sgr_start = "\33[%sm\33[K";
static const char *sgr_end = "\33[m\33[K";

/_ SGR utility functions. _/
static void
pr_sgr_start(char const *s)
{
if (*s)
print_start_colorize(sgr_start, s);
}
static void
pr_sgr_end(char const *s)
{
if (*s)
print_end_colorize(sgr_end);
}
static void
pr_sgr_start_if(char const *s)
{
if (color_option)
pr_sgr_start(s);
}
static void
pr_sgr_end_if(char const *s)
{
if (color_option)
pr_sgr_end(s);
}

struct color_cap
{
const char *name;
const char \*\*var;
void (*fct)(void);
};

static void
color_cap_mt_fct(void)
{
/_ Our caller just set selected_match_color. _/
context_match_color = selected_match_color;
}

static void
color_cap_rv_fct(void)
{
/_ By this point, it was 1 (or already -1). _/
color_option = -1; /_ That's still != 0. _/
}

static void
color_cap_ne_fct(void)
{
sgr_start = "\33[%sm";
sgr_end = "\33[m";
}

/_ For GREP_COLORS. _/
static const struct color*cap color_dict[] =
{
{"mt", &selected_match_color, color_cap_mt_fct}, /* both ms/mc */
{"ms", &selected_match_color, nullptr}, /* selected matched text */
{"mc", &context_match_color, nullptr}, /* context matched text */
{"fn", &filename_color, nullptr}, /* filename */
{"ln", &line_num_color, nullptr}, /* line number */
{"bn", &byte_num_color, nullptr}, /* byte (sic) offset */
{"se", &sep_color, nullptr}, /* separator */
{"sl", &selected_line_color, nullptr}, /* selected lines */
{"cx", &context_line_color, nullptr}, /* context lines */
{"rv", nullptr, color_cap_rv_fct}, /* -v reverses sl/cx */
{"ne", nullptr, color_cap_ne_fct}, /\* no EL on SGR*\* \*/
{nullptr, nullptr, nullptr}};

/_ Saved errno value from failed output functions on stdout.
prline polls this to decide whether to die.
Setting it to nonzero just before exiting can prevent clean_up_stdout
from misbehaving on a buggy OS where 'close (STDOUT_FILENO)' fails
with EACCES. _/
static int stdout_errno;

static void
putchar_errno(int c)
{
if (putchar(c) < 0)
stdout_errno = errno;
}

static void
fputs_errno(char const \*s)
{
if (fputs(s, stdout) < 0)
stdout_errno = errno;
}

static void \_GL_ATTRIBUTE_FORMAT_PRINTF_STANDARD(1, 2)
printf_errno(char const \*format, ...)
{
va_list ap;
va_start(ap, format);
if (vfprintf(stdout, format, ap) < 0)
stdout_errno = errno;
va_end(ap);
}

static void
fwrite_errno(void const \*ptr, idx_t size, idx_t nmemb)
{
if (fwrite(ptr, size, nmemb, stdout) != nmemb)
stdout_errno = errno;
}

static void
fflush_errno(void)
{
if (fflush(stdout) != 0)
stdout_errno = errno;
}

static struct exclude *excluded_patterns[2];
static struct exclude *excluded_directory_patterns[2];
/_ Short options. _/
static char const short_options[] =
"0123456789A:B:C:D:EFGHIPTUVX:abcd:e:f:hiLlm:noqRrsuvwxyZz";

/_ Non-boolean long options that have no corresponding short equivalents. _/
enum
{
BINARY_FILES_OPTION = CHAR_MAX + 1,
COLOR_OPTION,
EXCLUDE_DIRECTORY_OPTION,
EXCLUDE_OPTION,
EXCLUDE_FROM_OPTION,
GROUP_SEPARATOR_OPTION,
INCLUDE_OPTION,
LINE_BUFFERED_OPTION,
LABEL_OPTION,
NO_IGNORE_CASE_OPTION
};

/_ Long options equivalences. _/
static struct option const long_options[] =
{
{"basic-regexp", no_argument, nullptr, 'G'},
{"extended-regexp", no_argument, nullptr, 'E'},
{"fixed-regexp", no_argument, nullptr, 'F'},
{"fixed-strings", no_argument, nullptr, 'F'},
{"perl-regexp", no_argument, nullptr, 'P'},
{"after-context", required_argument, nullptr, 'A'},
{"before-context", required_argument, nullptr, 'B'},
{"binary-files", required_argument, nullptr, BINARY_FILES_OPTION},
{"byte-offset", no_argument, nullptr, 'b'},
{"context", required_argument, nullptr, 'C'},
{"color", optional_argument, nullptr, COLOR_OPTION},
{"colour", optional_argument, nullptr, COLOR_OPTION},
{"count", no_argument, nullptr, 'c'},
{"devices", required_argument, nullptr, 'D'},
{"directories", required_argument, nullptr, 'd'},
{"exclude", required_argument, nullptr, EXCLUDE_OPTION},
{"exclude-from", required_argument, nullptr, EXCLUDE_FROM_OPTION},
{"exclude-dir", required_argument, nullptr, EXCLUDE_DIRECTORY_OPTION},
{"file", required_argument, nullptr, 'f'},
{"files-with-matches", no_argument, nullptr, 'l'},
{"files-without-match", no_argument, nullptr, 'L'},
{"group-separator", required_argument, nullptr, GROUP_SEPARATOR_OPTION},
{"help", no_argument, &show_help, 1},
{"include", required_argument, nullptr, INCLUDE_OPTION},
{"ignore-case", no_argument, nullptr, 'i'},
{"no-ignore-case", no_argument, nullptr, NO_IGNORE_CASE_OPTION},
{"initial-tab", no_argument, nullptr, 'T'},
{"label", required_argument, nullptr, LABEL_OPTION},
{"line-buffered", no_argument, nullptr, LINE_BUFFERED_OPTION},
{"line-number", no_argument, nullptr, 'n'},
{"line-regexp", no_argument, nullptr, 'x'},
{"max-count", required_argument, nullptr, 'm'},

        {"no-filename", no_argument, nullptr, 'h'},
        {"no-group-separator", no_argument, nullptr, GROUP_SEPARATOR_OPTION},
        {"no-messages", no_argument, nullptr, 's'},
        {"null", no_argument, nullptr, 'Z'},
        {"null-data", no_argument, nullptr, 'z'},
        {"only-matching", no_argument, nullptr, 'o'},
        {"quiet", no_argument, nullptr, 'q'},
        {"recursive", no_argument, nullptr, 'r'},
        {"dereference-recursive", no_argument, nullptr, 'R'},
        {"regexp", required_argument, nullptr, 'e'},
        {"invert-match", no_argument, nullptr, 'v'},
        {"silent", no_argument, nullptr, 'q'},
        {"text", no_argument, nullptr, 'a'},
        {"binary", no_argument, nullptr, 'U'},
        {"version", no_argument, nullptr, 'V'},
        {"with-filename", no_argument, nullptr, 'H'},
        {"word-regexp", no_argument, nullptr, 'w'},
        {0, 0, 0, 0}};

/_ Define flags declared in grep.h. _/
bool match_icase;
bool match_words;
bool match_lines;
char eolbyte;

/_ For error messages. _/
/_ The input file name, or (if standard input) null or a --label argument. _/
static char const _filename;
/_ Omit leading "./" from file names in diagnostics. \*/
static bool omit_dot_slash;
static bool errseen;

/_ True if output from the current input file has been suppressed
because an output line had an encoding error. _/
static bool encoding_error_output;

enum directories_type
{
READ_DIRECTORIES = 2,
RECURSE_DIRECTORIES,
SKIP_DIRECTORIES
};

/_ How to handle directories. _/
static char const \*const directories_args[] =
{
"read", "recurse", "skip", nullptr};
static enum directories_type const directories_types[] =
{
READ_DIRECTORIES, RECURSE_DIRECTORIES, SKIP_DIRECTORIES};
ARGMATCH_VERIFY(directories_args, directories_types);

static enum directories_type directories = READ_DIRECTORIES;

enum
{
basic_fts_options = FTS_CWDFD | FTS_NOSTAT | FTS_TIGHT_CYCLE_CHECK
};
static int fts_options = basic_fts_options | FTS_COMFOLLOW | FTS_PHYSICAL;

/_ How to handle devices. _/
static enum {
READ_COMMAND_LINE_DEVICES,
READ_DEVICES,
SKIP_DEVICES
} devices = READ_COMMAND_LINE_DEVICES;

static bool grepfile(int, char const \*, bool, bool);
static bool grepdesc(int, bool);

static bool
is_device_mode(mode_t m)
{
return S_ISCHR(m) || S_ISBLK(m) || S_ISSOCK(m) || S_ISFIFO(m);
}

static bool
skip_devices(bool command_line)
{
return (devices == SKIP_DEVICES || ((devices == READ_COMMAND_LINE_DEVICES) & !command_line));
}

/_ Return if ST->st_size is defined. Assume the file is not a
symbolic link. _/
static bool
usable_st_size(struct stat const \*st)
{
return S_ISREG(st->st_mode) || S_TYPEISSHM(st) || S_TYPEISTMO(st);
}

/_ Lame substitutes for SEEK_DATA and SEEK_HOLE on platforms lacking them.
Do not rely on these finding data or holes if they equal SEEK_SET. _/
#ifndef SEEK_DATA
enum
{
SEEK_DATA = SEEK_SET
};
#endif
#ifndef SEEK_HOLE
enum
{
SEEK_HOLE = SEEK_SET
};
#endif

/_ True if lseek with SEEK_CUR or SEEK_DATA failed on the current input. _/
static bool seek_failed;
static bool seek_data_failed;

/_ Functions we'll use to search. _/
typedef void *(*compile_fp_t)(char *, idx_t, reg_syntax_t, bool);
typedef ptrdiff_t (*execute_fp_t)(void _, char const _, idx_t, idx_t _,
char const _);
static execute_fp_t execute;
static void \*compiled_pattern;

char const \*
input*filename(void)
{
if (!filename)
filename = *("(standard input)");
return filename;
}

/_ Unless requested, diagnose an error about the input file. _/
static void
suppressible_error(int errnum)
{
if (!suppress_errors)
error(0, errnum, "%s", input_filename());
errseen = true;
}

/_ If there has already been a write error, don't bother closing
standard output, as that might elicit a duplicate diagnostic. _/
static void
clean_up_stdout(void)
{
if (!stdout_errno)
close_stdout();
}

/_ A cast to TYPE of VAL. Use this when TYPE is a pointer type, VAL
is properly aligned for TYPE, and 'gcc -Wcast-align' cannot infer
the alignment and would otherwise complain about the cast. _/
#if 4 < **GNUC** + (6 <= **GNUC_MINOR**)
#define CAST*ALIGNED(type, val) \
 ({ \
 **typeof**(val) val* = val; \
 _Pragma("GCC diagnostic push") \
 \_Pragma("GCC diagnostic ignored \"-Wcast-align\"")(type) val_; \
 \_Pragma("GCC diagnostic pop") \
 })
#else
#define CAST_ALIGNED(type, val) ((type)(val))
#endif

/_ An unsigned type suitable for fast matching. _/
typedef uintmax_t uword;
static uword const uword_max = UINTMAX_MAX;
enum
{
uword_size = sizeof(uword)
}; /_ For when a signed size is wanted. _/

struct localeinfo localeinfo;

/_ A mask to test for unibyte characters, with the pattern repeated to
fill a uword. For a multibyte character encoding where
all bytes are unibyte characters, this is 0. For UTF-8, this is
0x808080.... For encodings where unibyte characters have no discerned
pattern, this is all 1s. The unsigned char C is a unibyte
character if C & UNIBYTE_MASK is zero. If the uword W is the
concatenation of bytes, the bytes are all unibyte characters
if W & UNIBYTE_MASK is zero. _/
static uword unibyte_mask;

static void
initialize_unibyte_mask(void)
{
/_ For each encoding error I that MASK does not already match,
accumulate I's most significant 1 bit by ORing it into MASK.
Although any 1 bit of I could be used, in practice high-order
bits work better. _/
unsigned char mask = 0;
int ms1b = 1;
for (int i = 1; i <= UCHAR_MAX; i++)
if ((localeinfo.sbclen[i] != 1) & !(mask & i))
{
while (ms1b _ 2 <= i)
ms1b _= 2;
mask |= ms1b;
}

    /* Now MASK will detect any encoding-error byte, although it may
       cry wolf and it may not be optimal.  Build a uword-length mask by
       repeating MASK.  */
    unibyte_mask = uword_max / UCHAR_MAX * mask;

}

/_ Skip the easy bytes in a buffer that is guaranteed to have a sentinel
that is not easy, and return a pointer to the first non-easy byte.
The easy bytes all have UNIBYTE_MASK off. _/
static char const *\_GL_ATTRIBUTE_PURE
skip_easy_bytes(char const *buf)
{
/_ Search a byte at a time until the pointer is aligned, then a
uword at a time until a match is found, then a byte at a time to
identify the exact byte. The uword search may go slightly past
the buffer end, but that's benign. _/
char const *p;
uword const *s;
for (p = buf; (uintptr_t)p % uword_size != 0; p++)
if (to_uchar(_p) & unibyte_mask)
return p;
for (s = CAST_ALIGNED(uword const _, p); !(_s & unibyte_mask); s++)
continue;
for (p = (char const _)s; !(to_uchar(\*p) & unibyte_mask); p++)
continue;
return p;
}

/_ Return true if BUF, of size SIZE, has an encoding error.
BUF must be followed by at least uword_size bytes,
the first of which may be modified. _/
static bool
buf_has_encoding_errors(char \*buf, idx_t size)
{
if (!unibyte_mask)
return false;

    mbstate_t mbs;
    mbszero(&mbs);
    ptrdiff_t clen;

    buf[size] = -1;
    for (char const *p = buf; (p = skip_easy_bytes(p)) < buf + size; p += clen)
    {
        clen = imbrlen(p, buf + size - p, &mbs);
        if (clen < 0)
            return true;
    }

    return false;

}

/_ Return true if BUF, of size SIZE, has a null byte.
BUF must be followed by at least one byte,
which may be arbitrarily written to or read from. _/
static bool
buf_has_nulls(char \*buf, idx_t size)
{
buf[size] = 0;
return strlen(buf) != size;
}

/_ Return true if a file is known to contain null bytes.
SIZE bytes have already been read from the file
with descriptor FD and status ST. _/
static bool
file_must_have_nulls(idx_t size, int fd, struct stat const _st)
{
/_ If the file has holes, it must contain a null byte somewhere. \*/
if (SEEK_HOLE != SEEK_SET && !seek_failed && usable_st_size(st) && size < st->st_size)
{
off_t cur = size;
if (O_BINARY || fd == STDIN_FILENO)
{
cur = lseek(fd, 0, SEEK_CUR);
if (cur < 0)
return false;
}

        /* Look for a hole after the current location.  */
        off_t hole_start = lseek(fd, cur, SEEK_HOLE);
        if (0 <= hole_start)
        {
            if (lseek(fd, cur, SEEK_SET) < 0)
                suppressible_error(errno);
            if (hole_start < st->st_size)
                return true;
        }
    }

    return false;

}

/* Convert STR to a nonnegative integer, storing the result in *OUT.
STR must be a valid context length argument; report an error if it
isn't. Silently ceiling _OUT at the maximum value, as that is
practically equivalent to infinity for grep's purposes. _/
static void
context*length_arg(char const *str, intmax_t *out)
{
switch (xstrtoimax(str, 0, 10, out, ""))
{
case LONGINT_OK:
case LONGINT_OVERFLOW:
if (0 <= \*out)
break;
FALLTHROUGH;
default:
die(EXIT_TROUBLE, 0, "%s: %s", str,
*("invalid context length argument"));
}
}

/_ Return the add_exclude options suitable for excluding a file name.
If COMMAND_LINE, it is a command-line file name. _/
static int
exclude_options(bool command_line)
{
return EXCLUDE_WILDCARDS | (command_line ? 0 : EXCLUDE_ANCHORED);
}

/_ Return true if the file with NAME should be skipped.
If COMMAND_LINE, it is a command-line argument.
If IS_DIR, it is a directory. _/
static bool
skipped_file(char const \*name, bool command_line, bool is_dir)
{
struct exclude \*\*pats;
if (!is_dir)
pats = excluded_patterns;
else if (directories == SKIP_DIRECTORIES)
return true;
else if (command_line && omit_dot_slash)
return false;
else
pats = excluded_directory_patterns;
return pats[command_line] && excluded_file_name(pats[command_line], name);
}

/_ Hairy buffering mechanism for grep. The intent is to keep
all reads aligned on a page boundary and multiples of the
page size, unless a read yields a partial page. _/

static char _buffer; /_ Base of buffer. _/
static idx_t bufalloc; /_ Allocated buffer size, counting slop. _/
static int bufdesc; /_ File descriptor. */
static char *bufbeg; /_ Beginning of user-visible stuff. _/
static char _buflim; /_ Limit of user-visible stuff. _/
static idx_t pagesize; /_ alignment of memory pages _/
static idx_t good_readsize; /_ good size to pass to 'read' _/
static off_t bufoffset; /_ Read offset. _/
static off_t after_last_match; /_ Pointer after last matching line that
would have been output if we were
outputting characters. _/
static bool skip_nuls; /_ Skip '\0' in data. _/
static bool skip_empty_lines; /_ Skip empty lines in data. _/
static intmax_t totalnl; /_ Total newline count before lastnl. \*/

/_ Minimum value for good_readsize.
If it's too small, there are more syscalls;
if too large, it wastes memory and likely cache.
Use 96 KiB as it gave good results in a benchmark in 2018
(see 2018-09-06 commit labeled "grep: triple initial buffer size: 32k->96k")
even though the same benchmark in 2024 found no significant
difference for values from 32 KiB to 1024 KiB on Ubuntu 24.04.1 LTS
with an Intel Xeon W-1350. _/
enum
{
GOOD_READSIZE_MIN = 96 \* 1024
};

/_ Return VAL aligned to the next multiple of ALIGNMENT. VAL can be
an integer or a pointer. Both args must be free of side effects. _/
#define ALIGN_TO(val, alignment) \
 ((uintptr_t)(val) % (alignment) == 0 \
 ? (val) \
 : (val) + ((alignment) - (uintptr_t)(val) % (alignment)))

/_ Add two numbers that count input bytes or lines, and report an
error if the addition overflows. _/
static intmax*t
add_count(intmax_t a, idx_t b)
{
intmax_t sum;
if (ckd_add(&sum, a, b))
die(EXIT_TROUBLE, 0, *("input is too large to count"));
return sum;
}

/_ Return true if BUF (of size SIZE) is all zeros. _/
static bool
all_zeros(char const *buf, idx_t size)
{
for (char const *p = buf; p < buf + size; p++)
if (\*p)
return false;
return true;
}

/_ Reset the buffer for a new file, returning false if we should skip it.
Initialize on the first time through. _/
static bool
reset(int fd, struct stat const \*st)
{
bufbeg = buflim = ALIGN_TO(buffer + 1, pagesize);
bufbeg[-1] = eolbyte;
bufdesc = fd;
bufoffset = fd == STDIN_FILENO ? lseek(fd, 0, SEEK_CUR) : 0;
seek_failed = bufoffset < 0;

    /* Assume SEEK_DATA fails if SEEK_CUR does.  */
    seek_data_failed = seek_failed;

    if (seek_failed)
    {
        if (errno != ESPIPE)
        {
            suppressible_error(errno);
            return false;
        }
        bufoffset = 0;
    }
    return true;

}

/_ Read new stuff into the buffer, saving the specified
amount of old stuff. When we're done, 'bufbeg' points
to the beginning of the buffer contents, and 'buflim'
points just after the end. Return false if there's an error. _/
static bool
fillbuf(idx_t save, struct stat const *st)
{
char *readbuf;

    /* After BUFLIM, we need room for a good-sized read plus a
       trailing uword.  */
    idx_t min_after_buflim = good_readsize + uword_size;

    if (min_after_buflim <= buffer + bufalloc - buflim)
        readbuf = buflim;
    else
    {
        char *newbuf;

        /* For data to be searched we need room for the saved bytes,
           plus at least a good-sized read.  */
        idx_t minsize = save + good_readsize;

        /* Add enough room so that the buffer is aligned and has room
           for byte sentinels fore and aft, and so that a uword can
           be read aft.  */
        ptrdiff_t incr_min = minsize - bufalloc + min_after_buflim;

        if (incr_min <= 0)
            newbuf = buffer;
        else
        {
            /* Try not to allocate more memory than the file size indicates,
               as that might cause unnecessary memory exhaustion if the file
               is large.  However, do not use the original file size as a
               heuristic if we've already read past the file end, as most
               likely the file is growing.  */
            ptrdiff_t alloc_max = -1;
            if (usable_st_size(st))
            {
                off_t to_be_read = st->st_size - bufoffset;
                ptrdiff_t a;
                if (0 <= to_be_read && !ckd_add(&a, to_be_read, save + min_after_buflim))
                    alloc_max = MAX(a, bufalloc + incr_min);
            }

            newbuf = xpalloc(nullptr, &bufalloc, incr_min, alloc_max, 1);
        }

        readbuf = ALIGN_TO(newbuf + 1 + save, pagesize);
        idx_t moved = save + 1; /* Move the preceding byte sentinel too.  */
        memmove(readbuf - moved, buflim - moved, moved);
        if (0 < incr_min)
        {
            free(buffer);
            buffer = newbuf;
        }
    }

    bufbeg = readbuf - save;

    clear_asan_poison();

    ptrdiff_t fillsize;
    bool cc = true;

    while (true)
    {
        fillsize = safe_read(bufdesc, readbuf, good_readsize);
        if (fillsize < 0)
        {
            fillsize = 0;
            cc = false;
        }
        bufoffset += fillsize;

        if (((fillsize == 0) | !skip_nuls) || !all_zeros(readbuf, fillsize))
            break;
        totalnl = add_count(totalnl, fillsize);

        if (SEEK_DATA != SEEK_SET && !seek_data_failed)
        {
            /* Solaris SEEK_DATA fails with errno == ENXIO in a hole at EOF.  */
            off_t data_start = lseek(bufdesc, bufoffset, SEEK_DATA);
            if (data_start < 0 && errno == ENXIO && usable_st_size(st) && bufoffset < st->st_size)
                data_start = lseek(bufdesc, 0, SEEK_END);

            if (data_start < 0)
                seek_data_failed = true;
            else
            {
                totalnl = add_count(totalnl, data_start - bufoffset);
                bufoffset = data_start;
            }
        }
    }

    buflim = readbuf + fillsize;

    /* Initialize the following word, because skip_easy_bytes and some
       matchers read (but do not use) those bytes.  This avoids false
       positive reports of these bytes being used uninitialized.  */
    memset(buflim, 0, uword_size);

    /* Mark the part of the buffer not filled by the read or set by
       the above memset call as ASAN-poisoned.  */
    asan_poison(buflim + uword_size, bufalloc - (buflim - buffer) - uword_size);

    return cc;

}

/_ Flags controlling the style of output. _/
static enum {
BINARY_BINARY_FILES,
TEXT_BINARY_FILES,
WITHOUT_MATCH_BINARY_FILES
} binary_files; /_ How to handle binary files. _/

/_ Options for output as a list of matching/non-matching files _/
static enum {
LISTFILES_NONE,
LISTFILES_MATCHING,
LISTFILES_NONMATCHING,
} list_files;

/_ Whether to output filenames. 1 means yes, 0 means no, and -1 means
'grep -r PATTERN FILE' was used and it is not known yet whether
FILE is a directory (which means yes) or not (which means no). _/
static int out_file;

static int filename_mask; /_ If zero, output nulls after filenames. _/
static bool out_quiet; /_ Suppress all normal output. _/
static bool out_invert; /_ Print nonmatching stuff. _/
static bool out_line; /_ Print line numbers. _/
static bool out_byte; /_ Print byte offsets. _/
static intmax_t out_before; /_ Lines of leading context. _/
static intmax_t out_after; /_ Lines of trailing context. _/
static bool count_matches; /_ Count matching lines. _/
static intmax_t max_count; /_ Max number of selected
lines from an input file. _/
static bool line_buffered; /_ Use line buffering. _/
static char _label; /_ Fake filename for stdin \*/

/_ Internal variables to keep track of byte count, context, etc. _/
static intmax_t totalcc; /_ Total character count before bufbeg. _/
static char const _lastnl; /_ Pointer after last newline counted. */
static char *lastout; /_ Pointer after last character output;
null if no character has been output
or if it's conceptually before bufbeg. _/
static intmax_t outleft; /_ Maximum number of selected lines. _/
static intmax_t pending; /_ Pending lines of output.
Always kept 0 if out_quiet is true. _/
static bool done_on_match; /_ Stop scanning file on first match. _/
static bool exit_on_match; /_ Exit on first match. _/
static bool dev_null_output; /_ Stdout is known to be /dev/null. _/
static bool binary; /_ Use binary rather than text I/O. _/

static void
nlscan(char const *lim)
{
idx_t newlines = 0;
for (char const *beg = lastnl; beg < lim; beg++)
{
beg = memchr(beg, eolbyte, lim - beg);
if (!beg)
break;
newlines++;
}
totalnl = add_count(totalnl, newlines);
lastnl = lim;
}

/_ Print the current filename. _/
static void
print_filename(void)
{
pr_sgr_start_if(filename_color);
fputs_errno(input_filename());
pr_sgr_end_if(filename_color);
}

/_ Print a character separator. _/
static void
print_sep(char sep)
{
pr_sgr_start_if(sep_color);
putchar_errno(sep);
pr_sgr_end_if(sep_color);
}

/_ Print a line number or a byte offset. _/
static void
print_offset(intmax_t pos, const char _color)
{
pr_sgr_start_if(color);
printf_errno("%_" PRIdMAX, offset_width, pos);
pr_sgr_end_if(color);
}

/\* Print a whole line head (filename, line, byte). The output data
starts at BEG and contains LEN bytes; it is followed by at least
uword_size bytes, the first of which may be temporarily modified.
The output data comes from what is perhaps a larger input line that
goes until LIM, where LIM[-1] is an end-of-line byte. Use SEP as
the separator on output.

Return true unless the line was suppressed due to an encoding error. \*/

static bool
print_line_head(char *beg, idx_t len, char const *lim, char sep)
{
if (binary_files != TEXT_BINARY_FILES)
{
char ch = beg[len];
bool encoding_errors = buf_has_encoding_errors(beg, len);
beg[len] = ch;
if (encoding_errors)
{
encoding_error_output = true;
return false;
}
}

    if (out_file)
    {
        print_filename();
        if (filename_mask)
            print_sep(sep);
        else
            putchar_errno(0);
    }

    if (out_line)
    {
        if (lastnl < lim)
        {
            nlscan(beg);
            totalnl = add_count(totalnl, 1);
            lastnl = lim;
        }
        print_offset(totalnl, line_num_color);
        print_sep(sep);
    }

    if (out_byte)
    {
        intmax_t pos = add_count(totalcc, beg - bufbeg);
        print_offset(pos, byte_num_color);
        print_sep(sep);
    }

    if (align_tabs && (out_file | out_line | out_byte) && len != 0)
        putchar_errno('\t');

    return true;

}

static char *
print_line_middle(char *beg, char *lim,
const char *line_color, const char *match_color)
{
idx_t match_size;
ptrdiff_t match_offset;
char *cur;
char *mid = nullptr;
char *b;

    for (cur = beg;
         (cur < lim && 0 <= (match_offset = execute(compiled_pattern, beg, lim - beg,
                                                    &match_size, cur)));
         cur = b + match_size)
    {
        b = beg + match_offset;

        /* Avoid matching the empty line at the end of the buffer. */
        if (b == lim)
            break;

        /* Avoid hanging on grep --color "" foo */
        if (match_size == 0)
        {
            /* Make minimal progress; there may be further non-empty matches.  */
            /* XXX - Could really advance by one whole multi-octet character.  */
            match_size = 1;
            if (!mid)
                mid = cur;
        }
        else
        {
            /* This function is called on a matching line only,
               but is it selected or rejected/context?  */
            if (only_matching)
            {
                char sep = out_invert ? SEP_CHAR_REJECTED : SEP_CHAR_SELECTED;
                if (!print_line_head(b, match_size, lim, sep))
                    return nullptr;
            }
            else
            {
                pr_sgr_start(line_color);
                if (mid)
                {
                    cur = mid;
                    mid = nullptr;
                }
                fwrite_errno(cur, 1, b - cur);
            }

            pr_sgr_start_if(match_color);
            fwrite_errno(b, 1, match_size);
            pr_sgr_end_if(match_color);
            if (only_matching)
                putchar_errno(eolbyte);
        }
    }

    if (only_matching)
        cur = lim;
    else if (mid)
        cur = mid;

    return cur;

}

static char *
print_line_tail(char *beg, const char *lim, const char *line_color)
{
idx_t eol_size;
idx_t tail_size;

    eol_size = (lim > beg && lim[-1] == eolbyte);
    eol_size += (lim - eol_size > beg && lim[-(1 + eol_size)] == '\r');
    tail_size = lim - eol_size - beg;

    if (tail_size > 0)
    {
        pr_sgr_start(line_color);
        fwrite_errno(beg, 1, tail_size);
        beg += tail_size;
        pr_sgr_end(line_color);
    }

    return beg;

}

static void
prline(char *beg, char *lim, char sep)
{
bool matching;
const char *line_color;
const char *match_color;

    if (!only_matching)
        if (!print_line_head(beg, lim - beg - 1, lim, sep))
            return;

    matching = (sep == SEP_CHAR_SELECTED) ^ out_invert;

    if (color_option)
    {
        line_color = (((sep == SEP_CHAR_SELECTED) ^ (out_invert && (color_option < 0)))
                          ? selected_line_color
                          : context_line_color);
        match_color = (sep == SEP_CHAR_SELECTED
                           ? selected_match_color
                           : context_match_color);
    }
    else
        line_color = match_color = nullptr; /* Shouldn't be used.  */

    if ((only_matching && matching) || (color_option && (*line_color || *match_color)))
    {
        /* We already know that non-matching lines have no match (to colorize). */
        if (matching && (only_matching || *match_color))
        {
            beg = print_line_middle(beg, lim, line_color, match_color);
            if (!beg)
                return;
        }

        if (!only_matching && *line_color)
        {
            /* This code is exercised at least when grep is invoked like this:
               echo k| GREP_COLORS='sl=01;32' src/grep k --color=always  */
            beg = print_line_tail(beg, lim, line_color);
        }
    }

    if (!only_matching && lim > beg)
        fwrite_errno(beg, 1, lim - beg);

    if (line_buffered)
        fflush_errno();

    if (stdout_errno)
        die(EXIT_TROUBLE, stdout_errno, _("write error"));

    lastout = lim;

}

/_ Print pending lines of trailing context prior to LIM. _/
static void
prpending(char const *lim)
{
if (!lastout)
lastout = bufbeg;
for (; 0 < pending && lastout < lim; pending--)
{
char *nl = rawmemchr(lastout, eolbyte);
prline(lastout, nl + 1, SEP_CHAR_REJECTED);
}
}

/_ Output the lines between BEG and LIM. Deal with context. _/
static void
prtext(char *beg, char *lim)
{
static bool used; /_ Avoid printing SEP_STR_GROUP before any output. _/
char eol = eolbyte;

    if (!out_quiet && pending > 0)
        prpending(beg);

    char *p = beg;

    if (!out_quiet)
    {
        /* Deal with leading context.  */
        char const *bp = lastout ? lastout : bufbeg;
        intmax_t i;
        for (i = 0; i < out_before; ++i)
            if (p > bp)
                do
                    --p;
                while (p[-1] != eol);

        /* Print the group separator unless the output is adjacent to
           the previous output in the file.  */
        if ((0 <= out_before || 0 <= out_after) && used && p != lastout && group_separator)
        {
            pr_sgr_start_if(sep_color);
            fputs_errno(group_separator);
            pr_sgr_end_if(sep_color);
            putchar_errno('\n');
        }

        while (p < beg)
        {
            char *nl = rawmemchr(p, eol);
            nl++;
            prline(p, nl, SEP_CHAR_REJECTED);
            p = nl;
        }
    }

    intmax_t n;
    if (out_invert)
    {
        /* One or more lines are output.  */
        for (n = 0; p < lim && n < outleft; n++)
        {
            char *nl = rawmemchr(p, eol);
            nl++;
            if (!out_quiet)
                prline(p, nl, SEP_CHAR_SELECTED);
            p = nl;
        }
    }
    else
    {
        /* Just one line is output.  */
        if (!out_quiet)
            prline(beg, lim, SEP_CHAR_SELECTED);
        n = 1;
        p = lim;
    }

    after_last_match = bufoffset - (buflim - p);
    pending = out_quiet ? 0 : MAX(0, out_after);
    used = true;
    outleft -= n;

}

/* Replace all NUL bytes in buffer P (which ends at LIM) with EOL.
This avoids running out of memory when binary input contains a long
sequence of zeros, which would otherwise be considered to be part
of a long line. *LIM should be EOL. */
static void
zap_nuls(char *p, char *lim, char eol)
{
if (eol)
while (true)
{
*lim = '\0';
p += strlen(p);
*lim = eol;
if (p == lim)
break;
do
*p++ = eol;
while (!\*p);
}
}

/_ Scan the specified portion of the buffer, matching lines (or
between matching lines if OUT_INVERT is true). Return a count of
lines printed. Replace all NUL bytes with NUL_ZAPPER as we go. _/
static intmax_t
grepbuf(char *beg, char const *lim)
{
intmax_t outleft0 = outleft;
char \*endp;

    for (char *p = beg; p < lim; p = endp)
    {
        idx_t match_size;
        ptrdiff_t match_offset = execute(compiled_pattern, p, lim - p,
                                         &match_size, nullptr);
        if (match_offset < 0)
        {
            if (!out_invert)
                break;
            match_offset = lim - p;
            match_size = 0;
        }
        char *b = p + match_offset;
        endp = b + match_size;
        /* Avoid matching the empty line at the end of the buffer. */
        if (!out_invert && b == lim)
            break;
        if (!out_invert || p < b)
        {
            if (list_files != LISTFILES_NONE)
                return 1;
            char *prbeg = out_invert ? p : b;
            char *prend = out_invert ? b : endp;
            prtext(prbeg, prend);
            if (!outleft || done_on_match)
            {
                if (exit_on_match)
                {
                    stdout_errno = -1;
                    exit(EXIT_SUCCESS);
                }
                break;
            }
        }
    }

    return outleft0 - outleft;

}

/* Search a given (non-directory) file. Return a count of lines printed.
Set *INEOF to true if end-of-file reached. */
static intmax_t
grep(int fd, struct stat const *st, bool \*ineof)
{
intmax_t nlines, i;
idx_t residue, save;
char eol = eolbyte;
char nul_zapper = '\0';
bool done_on_match_0 = done_on_match;
bool out_quiet_0 = out_quiet;

    /* The value of NLINES when nulls were first deduced in the input;
       this is not necessarily the same as the number of matching lines
       before the first null.  -1 if no input nulls have been deduced.  */
    intmax_t nlines_first_null = -1;

    if (!reset(fd, st))
        return 0;

    totalcc = 0;
    lastout = 0;
    totalnl = 0;
    outleft = max_count;
    after_last_match = 0;
    pending = 0;
    skip_nuls = skip_empty_lines && !eol;
    encoding_error_output = false;

    nlines = 0;
    residue = 0;
    save = 0;

    if (!fillbuf(save, st))
    {
        suppressible_error(errno);
        return 0;
    }

    offset_width = 0;
    if (align_tabs)
    {
        /* Width is log of maximum number.  Line numbers are origin-1.  */
        intmax_t num = usable_st_size(st) ? st->st_size : INTMAX_MAX;
        num += out_line && num < INTMAX_MAX;
        do
            offset_width++;
        while ((num /= 10) != 0);
    }

    for (bool firsttime = true;; firsttime = false)
    {
        if (nlines_first_null < 0 && eol && binary_files != TEXT_BINARY_FILES && (buf_has_nulls(bufbeg, buflim - bufbeg) || (firsttime && file_must_have_nulls(buflim - bufbeg, fd, st))))
        {
            if (binary_files == WITHOUT_MATCH_BINARY_FILES)
                return 0;
            if (!count_matches)
            {
                out_quiet = true;
                if (max_count == INTMAX_MAX)
                    done_on_match = true;
            }
            nlines_first_null = nlines;
            nul_zapper = eol;
            skip_nuls = skip_empty_lines;
        }

        lastnl = bufbeg;
        if (lastout)
            lastout = bufbeg;

        char *beg = bufbeg + save;

        /* no more data to scan (eof) except for maybe a residue -> break */
        if (beg == buflim)
        {
            *ineof = true;
            break;
        }

        zap_nuls(beg, buflim, nul_zapper);

        /* Determine new residue (the length of an incomplete line at the end of
           the buffer, 0 means there is no incomplete last line).  */
        char *last_eol = memrchr(beg, eol, buflim - beg);
        beg -= residue;
        char *lim = last_eol ? last_eol + 1 : beg;
        residue = buflim - lim;

        if (beg < lim)
        {
            if (outleft)
                nlines += grepbuf(beg, lim);
            if (pending)
                prpending(lim);
            if ((!outleft && !pending) || (done_on_match && MAX(0, nlines_first_null) < nlines))
                goto finish_grep;
        }

        /* The last OUT_BEFORE lines at the end of the buffer will be needed as
           leading context if there is a matching line at the begin of the
           next data. Make beg point to their begin.  */
        i = 0;
        beg = lim;
        while (i < out_before && beg > bufbeg && beg != lastout)
        {
            ++i;
            do
                --beg;
            while (beg[-1] != eol);
        }

        /* Detect whether leading context is adjacent to previous output.  */
        if (beg != lastout)
            lastout = 0;

        /* Handle some details and read more data to scan.  */
        save = residue + lim - beg;
        if (out_byte)
            totalcc = add_count(totalcc, buflim - bufbeg - save);
        if (out_line)
            nlscan(beg);
        if (!fillbuf(save, st))
        {
            suppressible_error(errno);
            goto finish_grep;
        }
    }
    if (residue)
    {
        *buflim++ = eol;
        if (outleft)
            nlines += grepbuf(bufbeg + save - residue, buflim);
        if (pending)
            prpending(buflim);
    }

finish*grep:
done_on_match = done_on_match_0;
out_quiet = out_quiet_0;
if (binary_files == BINARY_BINARY_FILES && !out_quiet && (encoding_error_output || (0 <= nlines_first_null && nlines_first_null < nlines)))
error(0, 0, *("%s: binary file matches"), input_filename());
return nlines;
}

static bool
grepdirent(FTS *fts, FTSENT *ent, bool command_line)
{
bool follow;
command_line &= ent->fts_level == FTS_ROOTLEVEL;

    if (ent->fts_info == FTS_DP)
        return true;

    if (!command_line && skipped_file(ent->fts_name, false,
                                      (ent->fts_info == FTS_D || ent->fts_info == FTS_DC || ent->fts_info == FTS_DNR)))
    {
        fts_set(fts, ent, FTS_SKIP);
        return true;
    }

    filename = ent->fts_path;
    if (omit_dot_slash && filename[1])
        filename += 2;
    follow = (fts->fts_options & FTS_LOGICAL || (fts->fts_options & FTS_COMFOLLOW && command_line));

    switch (ent->fts_info)
    {
    case FTS_D:
        if (directories == RECURSE_DIRECTORIES)
            return true;
        fts_set(fts, ent, FTS_SKIP);
        break;

    case FTS_DC:
        if (!suppress_errors)
            error(0, 0, _("%s: warning: recursive directory loop"), filename);
        return true;

    case FTS_DNR:
    case FTS_ERR:
    case FTS_NS:
        suppressible_error(ent->fts_errno);
        return true;

    case FTS_DEFAULT:
    case FTS_NSOK:
        if (skip_devices(command_line))
        {
            struct stat *st = ent->fts_statp;
            struct stat st1;
            if (!st->st_mode)
            {
                /* The file type is not already known.  Get the file status
                   before opening, since opening might have side effects
                   on a device.  */
                int flag = follow ? 0 : AT_SYMLINK_NOFOLLOW;
                if (fstatat(fts->fts_cwd_fd, ent->fts_accpath, &st1, flag) != 0)
                {
                    suppressible_error(errno);
                    return true;
                }
                st = &st1;
            }
            if (is_device_mode(st->st_mode))
                return true;
        }
        break;

    case FTS_F:
    case FTS_SLNONE:
        break;

    case FTS_SL:
    case FTS_W:
        return true;

    default:
        abort();
    }

    return grepfile(fts->fts_cwd_fd, ent->fts_accpath, follow, command_line);

}

/_ True if errno is ERR after 'open ("symlink", ... O_NOFOLLOW ...)'.
POSIX specifies ELOOP, but it's EMLINK on FreeBSD and EFTYPE on NetBSD. _/
static bool
open_symlink_nofollow_error(int err)
{
if (err == ELOOP || err == EMLINK)
return true;
#ifdef EFTYPE
if (err == EFTYPE)
return true;
#endif
return false;
}

static bool
grepfile(int dirdesc, char const \*name, bool follow, bool command_line)
{
int oflag = (O_RDONLY | O_NOCTTY | (IGNORE_DUPLICATE_BRANCH_WARNING(binary ? O_BINARY : 0)) | (follow ? 0 : O_NOFOLLOW) | (skip_devices(command_line) ? O_NONBLOCK : 0));
int desc = openat_safer(dirdesc, name, oflag);
if (desc < 0)
{
if (follow || !open_symlink_nofollow_error(errno))
suppressible_error(errno);
return true;
}
return grepdesc(desc, command_line);
}

/_ Read all data from FD, with status ST. Return true if successful,
false (setting errno) otherwise. _/
static bool
drain_input(int fd, struct stat const _st)
{
ssize_t nbytes;
if (S_ISFIFO(st->st_mode) && dev_null_output)
{
#ifdef SPLICE_F_MOVE
/_ Should be faster, since it need not copy data to user space. \*/
nbytes = splice(fd, nullptr, STDOUT_FILENO, nullptr,
good_readsize, SPLICE_F_MOVE);
if (0 <= nbytes || errno != EINVAL)
{
while (0 < nbytes)
nbytes = splice(fd, nullptr, STDOUT_FILENO, nullptr,
good_readsize, SPLICE_F_MOVE);
return nbytes == 0;
}
#endif
}
while ((nbytes = safe_read(fd, buffer, bufalloc)))
if (nbytes < 0)
return false;
return true;
}

/_ Finish reading from FD, with status ST and where end-of-file has
been seen if INEOF. Typically this is a no-op, but when reading
from standard input this may adjust the file offset or drain a
pipe. _/

static void
finalize_input(int fd, struct stat const _st, bool ineof)
{
if (fd == STDIN_FILENO && (outleft
? (!ineof && (seek_failed || (lseek(fd, 0, SEEK_END) < 0
/_ Linux proc file system has EINVAL (Bug#25180). \*/
&& errno != EINVAL)) &&
!drain_input(fd, st))
: (bufoffset != after_last_match && !seek_failed && lseek(fd, after_last_match, SEEK_SET) < 0)))
suppressible_error(errno);
}

static bool
grepdesc(int desc, bool command_line)
{
intmax_t count;
bool status = true;
bool ineof = false;
struct stat st;

    /* Get the file status, possibly for the second time.  This catches
       a race condition if the directory entry changes after the
       directory entry is read and before the file is opened.  For
       example, normally DESC is a directory only at the top level, but
       there is an exception if some other process substitutes a
       directory for a non-directory while 'grep' is running.  */
    if (fstat(desc, &st) != 0)
    {
        suppressible_error(errno);
        goto closeout;
    }

    if (desc != STDIN_FILENO && skip_devices(command_line) && is_device_mode(st.st_mode))
        goto closeout;

    if (desc != STDIN_FILENO && command_line && skipped_file(filename, true, S_ISDIR(st.st_mode) != 0))
        goto closeout;

    /* Don't output file names if invoked as 'grep -r PATTERN NONDIRECTORY'.  */
    if (out_file < 0)
        out_file = !!S_ISDIR(st.st_mode);

    if (desc != STDIN_FILENO && directories == RECURSE_DIRECTORIES && S_ISDIR(st.st_mode))
    {
        /* Traverse the directory starting with its full name, because
           unfortunately fts provides no way to traverse the directory
           starting from its file descriptor.  */

        FTS *fts;
        FTSENT *ent;
        int opts = fts_options & ~(command_line ? 0 : FTS_COMFOLLOW);
        char *fts_arg[2];

        /* Close DESC now, to conserve file descriptors if the race
           condition occurs many times in a deep recursion.  */
        if (close(desc) != 0)
            suppressible_error(errno);

        fts_arg[0] = (char *)filename;
        fts_arg[1] = nullptr;
        fts = fts_open(fts_arg, opts, nullptr);

        if (!fts)
            xalloc_die();
        while ((ent = fts_read(fts)))
            status &= grepdirent(fts, ent, command_line);
        if (errno)
            suppressible_error(errno);
        if (fts_close(fts) != 0)
            suppressible_error(errno);
        return status;
    }
    if (desc != STDIN_FILENO && ((directories == SKIP_DIRECTORIES && S_ISDIR(st.st_mode)) || ((devices == SKIP_DEVICES || (devices == READ_COMMAND_LINE_DEVICES && !command_line)) && is_device_mode(st.st_mode))))
        goto closeout;

    /* If there is a regular file on stdout and the current file refers
       to the same i-node, we have to report the problem and skip it.
       Otherwise when matching lines from some other input reach the
       disk before we open this file, we can end up reading and matching
       those lines and appending them to the file from which we're reading.
       Then we'd have what appears to be an infinite loop that'd terminate
       only upon filling the output file system or reaching a quota.
       However, there is no risk of an infinite loop if grep is generating
       no output, i.e., with --silent, --quiet, -q.
       Similarly, with any of these:
         --max-count=N (-m) (for N >= 2)
         --files-with-matches (-l)
         --files-without-match (-L)
       there is no risk of trouble.
       For --max-count=1, grep stops after printing the first match,
       so there is no risk of malfunction.  But even --max-count=2, with
       input==output, while there is no risk of infloop, there is a race
       condition that could result in "alternate" output.  */
    if (!out_quiet && list_files == LISTFILES_NONE && 1 < max_count && S_ISREG(st.st_mode) && SAME_INODE(st, out_stat))
    {
        if (!suppress_errors)
            error(0, 0, _("%s: input file is also the output"), input_filename());
        errseen = true;
        goto closeout;
    }

    count = grep(desc, &st, &ineof);
    if (count_matches)
    {
        if (out_file)
        {
            print_filename();
            if (filename_mask)
                print_sep(SEP_CHAR_SELECTED);
            else
                putchar_errno(0);
        }
        printf_errno("%" PRIdMAX "\n", count);
        if (line_buffered)
            fflush_errno();
    }

    status = !count;

    if (list_files == LISTFILES_NONE)
        finalize_input(desc, &st, ineof);
    else if (list_files == (status ? LISTFILES_NONMATCHING : LISTFILES_MATCHING))
    {
        print_filename();
        putchar_errno('\n' & filename_mask);
        if (line_buffered)
            fflush_errno();
    }

closeout:
if (desc != STDIN_FILENO && close(desc) != 0)
suppressible_error(errno);
return status;
}

static bool
grep_command_line_arg(char const \*arg)
{
if (STREQ(arg, "-"))
{
filename = label;
if (binary)
xset_binary_mode(STDIN_FILENO, O_BINARY);
return grepdesc(STDIN_FILENO, true);
}
else
{
filename = arg;
return grepfile(AT_FDCWD, arg, true, true);
}
}

_Noreturn void usage(int);
void usage(int status)
{
if (status != 0)
{
fprintf(stderr, _("Usage: %s [OPTION]... PATTERNS [FILE]...\n"),
getprogname());
fprintf(stderr, _("Try '%s --help' for more information.\n"),
getprogname());
}
else
{
printf(_("Usage: %s [OPTION]... PATTERNS [FILE]...\n"), getprogname());
printf(_("Search for PATTERNS in each FILE.\n"));
printf(_("\
Example: %s -i 'hello world' menu.h main.c\n\
PATTERNS can contain multiple patterns separated by newlines.\n\
\n\
Pattern selection and interpretation:\n"),
getprogname());
printf(_("\
 -E, --extended-regexp PATTERNS are extended regular expressions\n\
 -F, --fixed-strings PATTERNS are strings\n\
 -G, --basic-regexp PATTERNS are basic regular expressions\n\
 -P, --perl-regexp PATTERNS are Perl regular expressions\n"));
/* -X is deliberately undocumented. */
printf(_("\
 -e, --regexp=PATTERNS use PATTERNS for matching\n\
 -f, --file=FILE take PATTERNS from FILE\n\
 -i, --ignore-case ignore case distinctions in patterns and data\n\
 --no-ignore-case do not ignore case distinctions (default)\n\
 -w, --word-regexp match only whole words\n\
 -x, --line-regexp match only whole lines\n\
 -z, --null-data a data line ends in 0 byte, not newline\n"));
printf(_("\
\n\
Miscellaneous:\n\
 -s, --no-messages suppress error messages\n\
 -v, --invert-match select non-matching lines\n\
 -V, --version display version information and exit\n\
 --help display this help text and exit\n"));
printf(_("\
\n\
Output control:\n\
 -m, --max-count=NUM stop after NUM selected lines\n\
 -b, --byte-offset print the byte offset with output lines\n\
 -n, --line-number print line number with output lines\n\
 --line-buffered flush output on every line\n\
 -H, --with-filename print file name with output lines\n\
 -h, --no-filename suppress the file name prefix on output\n\
 --label=LABEL use LABEL as the standard input file name prefix\n\
"));
printf(_("\
 -o, --only-matching show only nonempty parts of lines that match\n\
 -q, --quiet, --silent suppress all normal output\n\
 --binary-files=TYPE assume that binary files are TYPE;\n\
 TYPE is 'binary', 'text', or 'without-match'\n\
 -a, --text equivalent to --binary-files=text\n\
"));
printf(_("\
 -I equivalent to --binary-files=without-match\n\
 -d, --directories=ACTION how to handle directories;\n\
 ACTION is 'read', 'recurse', or 'skip'\n\
 -D, --devices=ACTION how to handle devices, FIFOs and sockets;\n\
 ACTION is 'read' or 'skip'\n\
 -r, --recursive like --directories=recurse\n\
 -R, --dereference-recursive likewise, but follow all symlinks\n\
"));
printf(_("\
 --include=GLOB search only files that match GLOB (a file pattern)"
"\n\
 --exclude=GLOB skip files that match GLOB\n\
 --exclude-from=FILE skip files that match any file pattern from FILE\n\
 --exclude-dir=GLOB skip directories that match GLOB\n\
"));
printf(_("\
 -L, --files-without-match print only names of FILEs with no selected lines\n\
 -l, --files-with-matches print only names of FILEs with selected lines\n\
 -c, --count print only a count of selected lines per FILE\n\
 -T, --initial-tab make tabs line up (if needed)\n\
 -Z, --null print 0 byte after FILE name\n"));
printf(_("\
\n\
Context control:\n\
 -B, --before-context=NUM print NUM lines of leading context\n\
 -A, --after-context=NUM print NUM lines of trailing context\n\
 -C, --context=NUM print NUM lines of output context\n\
"));
printf(_("\
 -NUM same as --context=NUM\n\
 --group-separator=SEP print SEP on line between matches with context\n\
 --no-group-separator do not print separator for matches with context\n\
 --color[=WHEN],\n\
 --colour[=WHEN] use markers to highlight the matching strings;\n\
 WHEN is 'always', 'never', or 'auto'\n\
 -U, --binary do not strip CR characters at EOL (MSDOS/Windows)\n\
\n"));
printf(\_("\
When FILE is '-', read standard input. If no FILE is given, read standard\n\
input, but with -r, recursively search the working directory instead. With\n\
fewer than two FILEs, assume -h. Exit status is 0 if any line is selected,\n\
1 otherwise; if any error occurs and -q is not given, the exit status is 2.\n"));
emit_bug_reporting_address();
}
exit(status);
}

/_ Pattern compilers and matchers. _/

static struct
{
char name[12];
int syntax; /_ used if compile == GEAcompile _/
compile_fp_t compile;
execute_fp_t execute;
} const matchers[] = {
{"grep", RE_SYNTAX_GREP, GEAcompile, EGexecute},
{"egrep", RE_SYNTAX_EGREP, GEAcompile, EGexecute},
{
"fgrep",
0,
Fcompile,
Fexecute,
},
{"awk", RE_SYNTAX_AWK, GEAcompile, EGexecute},
{"gawk", RE_SYNTAX_GNU_AWK, GEAcompile, EGexecute},
{"posixawk", RE_SYNTAX_POSIX_AWK, GEAcompile, EGexecute},
#if HAVE_LIBPCRE
{
"perl",
0,
Pcompile,
Pexecute,
},
#endif
};
/_ Keep these in sync with the 'matchers' table. _/
enum
{
E_MATCHER_INDEX = 1,
F_MATCHER_INDEX = 2,
G_MATCHER_INDEX = 0
};

/_ Return the index of the matcher corresponding to M if available.
MATCHER is the index of the previous matcher, or -1 if none.
Exit in case of conflicts or if M is not available. _/
static int
setmatcher(char const *m, int matcher)
{
for (int i = 0; i < sizeof matchers / sizeof *matchers; i++)
if (STREQ(m, matchers[i].name))
{
if (0 <= matcher && matcher != i)
die(EXIT*TROUBLE, 0, *("conflicting matchers specified"));
return i;
}

#if !HAVE*LIBPCRE
if (STREQ(m, "perl"))
die(EXIT_TROUBLE, 0,
*("Perl matching not supported in a --disable-perl-regexp build"));
#endif
die(EXIT*TROUBLE, 0, *("invalid matcher %s"), m);
}

/* Get the next non-digit option from ARGC and ARGV.
Return -1 if there are no more options.
Process any digit options that were encountered on the way,
and store the resulting integer into *DEFAULT_CONTEXT. */
static int
get_nondigit_option(int argc, char *const *argv, intmax_t *default_context)
{
static int prev_digit_optind = -1;
int this_digit_optind;
bool was_digit;
char buf[INT_BUFSIZE_BOUND(intmax_t) + 4];
char \*p = buf;
int opt;

    was_digit = false;
    this_digit_optind = optind;
    while (true)
    {
        opt = getopt_long(argc, (char **)argv, short_options,
                          long_options, nullptr);
        if (!c_isdigit(opt))
            break;

        if (prev_digit_optind != this_digit_optind || !was_digit)
        {
            /* Reset to start another context length argument.  */
            p = buf;
        }
        else
        {
            /* Suppress trivial leading zeros, to avoid incorrect
               diagnostic on strings like 00000000000.  */
            p -= buf[0] == '0';
        }

        if (p == buf + sizeof buf - 4)
        {
            /* Too many digits.  Append "..." to make context_length_arg
               complain about "X...", where X contains the digits seen
               so far.  */
            strcpy(p, "...");
            p += 3;
            break;
        }
        *p++ = opt;

        was_digit = true;
        prev_digit_optind = this_digit_optind;
        this_digit_optind = optind;
    }
    if (p != buf)
    {
        *p = '\0';
        context_length_arg(buf, default_context);
    }

    return opt;

}

/_ Parse GREP_COLORS. The default would look like:
GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
with boolean capabilities (ne and rv) unset (i.e., omitted).
No character escaping is needed or supported. _/
static void
parse_grep_colors(void)
{
const char *p;
char *q;
char *name;
char *val;

    p = getenv("GREP_COLORS"); /* Plural! */
    if (!p || *p == '\0')
        return;

    /* Work off a writable copy.  */
    q = xstrdup(p);

    name = q;
    val = nullptr;
    /* From now on, be well-formed or you're gone.  */
    for (;;)
        if (*q == ':' || *q == '\0')
        {
            char c = *q;
            struct color_cap const *cap;

            *q++ = '\0'; /* Terminate name or val.  */
            /* Empty name without val (empty cap)
             * won't match and will be ignored.  */
            for (cap = color_dict; cap->name; cap++)
                if (STREQ(cap->name, name))
                    break;
            /* If name unknown, go on for forward compatibility.  */
            if (cap->var && val)
                *(cap->var) = val;
            if (cap->fct)
                cap->fct();
            if (c == '\0')
                return;
            name = q;
            val = nullptr;
        }
        else if (*q == '=')
        {
            if (q == name || val)
                return;
            *q++ = '\0'; /* Terminate name.  */
            val = q;     /* Can be the empty string.  */
        }
        else if (!val)
            q++; /* Accumulate name.  */
        else if (*q == ';' || c_isdigit(*q))
            q++; /* Accumulate val.  Protect the terminal from being sent crap.  */
        else
            return;

}

/_ Return true if PAT (of length PATLEN) contains an encoding error. _/
static bool
contains_encoding_error(char const \*pat, idx_t patlen)
{
mbstate_t mbs;
mbszero(&mbs);
ptrdiff_t charlen;

    for (idx_t i = 0; i < patlen; i += charlen)
    {
        charlen = mb_clen(pat + i, patlen - i, &mbs);
        if (charlen < 0)
            return true;
    }
    return false;

}

/_ When ignoring case and (-E or -F or -G), then for each single-byte
character I, ok_fold[I] is 1 if every case folded counterpart of I
is also single-byte, and is -1 otherwise. _/
static signed char ok_fold[NCHAR];
static void
setup_ok_fold(void)
{
for (int i = 0; i < NCHAR; i++)
{
wint_t wi = localeinfo.sbctowc[i];
if (wi == WEOF)
continue;

        int ok = 1;
        char32_t folded[CASE_FOLDED_BUFSIZE];
        for (int n = case_folded_counterparts(wi, folded); 0 <= --n;)
        {
            char buf[MB_LEN_MAX];
            mbstate_t s;
            mbszero(&s);
            if (c32rtomb(buf, folded[n], &s) != 1)
            {
                ok = -1;
                break;
            }
        }
        ok_fold[i] = ok;
    }

}

/_ Return the number of bytes in the initial character of PAT, of size
PATLEN, if Fcompile can handle that character. Return -1 if
Fcompile cannot handle it. MBS is the multibyte conversion state.
PATLEN must be nonzero. _/

static ptrdiff_t
fgrep_icase_charlen(char const *pat, idx_t patlen, mbstate_t *mbs)
{
unsigned char pat0 = pat[0];

    /* If PAT starts with a single-byte character, Fcompile works if
       every case folded counterpart is also single-byte.  */
    if (localeinfo.sbctowc[pat0] != WEOF)
        return ok_fold[pat0];

    char32_t wc;
    size_t wn = mbrtoc32(&wc, pat, patlen, mbs);

    /* If PAT starts with an encoding error, Fcompile does not work.  */
    if (MB_LEN_MAX < wn)
        return -1;

    /* PAT starts with a multibyte character.  Fcompile works if the
       character has no case folded counterparts and toupper translates
       none of its encoding's bytes.  */
    char32_t folded[CASE_FOLDED_BUFSIZE];
    if (case_folded_counterparts(wc, folded))
        return -1;
    for (idx_t i = wn; 0 < --i;)
    {
        unsigned char c = pat[i];
        if (toupper(c) != c)
            return -1;
    }
    return wn;

}

/_ Return true if the -F patterns PAT, of size PATLEN, contain only
single-byte characters that case-fold only to single-byte
characters, or multibyte characters not subject to case folding,
and so can be processed by Fcompile. _/

static bool
fgrep_icase_available(char const \*pat, idx_t patlen)
{
mbstate_t mbs;
mbszero(&mbs);

    for (idx_t i = 0; i < patlen;)
    {
        int n = fgrep_icase_charlen(pat + i, patlen - i, &mbs);
        if (n < 0)
            return false;
        i += n;
    }

    return true;

}

/* Change the pattern *KEYS_P, of size _LEN_P, from fgrep to grep style. _/

void fgrep_to_grep_pattern(char \**keys_p, idx_t *len_p)
{
idx_t len = *len_p;
char *keys = *keys_p;
mbstate_t mb_state;
mbszero(&mb_state);
char *new_keys = xnmalloc(len + 1, 2);
char \*p = new_keys;

    for (ptrdiff_t n; len; keys += n, len -= n)
    {
        n = mb_clen(keys, len, &mb_state);
        switch (n)
        {
        case -2:
            n = len;
            FALLTHROUGH;
        default:
            p = mempcpy(p, keys, n);
            break;

        case -1:
            memset(&mb_state, 0, sizeof mb_state);
            n = 1;
            FALLTHROUGH;
        case 1:
            switch (*keys)
            {
            case '$':
            case '*':
            case '.':
            case '[':
            case '\\':
            case '^':
                *p++ = '\\';
                break;
            }
            *p++ = *keys;
            break;
        }
    }

    *p = '\n';
    free(*keys_p);
    *keys_p = new_keys;
    *len_p = p - new_keys;

}

/* If it is easy, convert the MATCHER-style patterns KEYS (of size
*LEN_P) to -F style, update *LEN_P to a possibly-smaller value, and
return F_MATCHER_INDEX. If not, leave KEYS and *LEN_P alone and
return MATCHER. This function is conservative and sometimes misses
conversions, e.g., it does not convert the -E pattern "(a|a|[aa])"
to the -F pattern "a". \*/

static int
try_fgrep_pattern(int matcher, char *keys, idx_t *len_p)
{
int result = matcher;
idx_t len = *len_p;
char *new_keys = ximalloc(len + 1);
char *p = new_keys;
char const *q = keys;
mbstate_t mb_state;
mbszero(&mb_state);

    while (len != 0)
    {
        switch (*q)
        {
        case '$':
        case '*':
        case '.':
        case '[':
        case '^':
            goto fail;

        case '(':
        case '+':
        case '?':
        case '{':
        case '|':
            /* There is no "case ')'" here, as "grep -E ')'" acts like
               "grep -E '\)'".  */
            if (matcher != G_MATCHER_INDEX)
                goto fail;
            break;

        case '\\':
            if (1 < len)
                switch (q[1])
                {
                case '\n':
                case 'B':
                case 'S':
                case 'W':
                case '\'':
                case '<':
                case 'b':
                case 's':
                case 'w':
                case '`':
                case '>':
                case '1':
                case '2':
                case '3':
                case '4':
                case '5':
                case '6':
                case '7':
                case '8':
                case '9':
                    goto fail;

                case '(':
                case '+':
                case '?':
                case '{':
                case '|':
                    /* Pass '\)' to GEAcompile so it can complain.  Otherwise,
                       "grep '\)'" would act like "grep ')'" while "grep '.*\)'
                       would be an error.  */
                case ')':
                    if (matcher == G_MATCHER_INDEX)
                        goto fail;
                    FALLTHROUGH;
                default:
                    q++, len--;
                    break;
                }
            break;
        }

        ptrdiff_t clen = (match_icase
                              ? fgrep_icase_charlen(q, len, &mb_state)
                              : mb_clen(q, len, &mb_state));
        if (clen < 0)
            goto fail;
        p = mempcpy(p, q, clen);
        q += clen;
        len -= clen;
    }

    if (*len_p != p - new_keys)
    {
        *len_p = p - new_keys;
        char *keys_end = mempcpy(keys, new_keys, p - new_keys);
        *keys_end = '\n';
    }
    result = F_MATCHER_INDEX;

fail:
free(new_keys);
return result;
}

int main(int argc, char \**argv)
{
char *keys = nullptr;
idx_t keycc = 0, keyalloc = 0;
int matcher = -1;
int opt;
int prev_optind, last_recursive;
intmax_t default_context;
FILE \*fp;
exit_failure = EXIT_TROUBLE;
initialize_main(&argc, &argv);

    /* Which command-line options have been specified for filename output.
       -1 for -h, 1 for -H, 0 for neither.  */
    int filename_option = 0;

    eolbyte = '\n';
    filename_mask = ~0;

    max_count = INTMAX_MAX;

    /* The value -1 means to use DEFAULT_CONTEXT. */
    out_after = out_before = -1;
    /* Default before/after context: changed by -C/-NUM options */
    default_context = -1;
    /* Changed by -o option */
    only_matching = false;

    /* Internationalization. */

#if defined HAVE_SETLOCALE
setlocale(LC_ALL, "");
#endif
#if defined ENABLE_NLS
bindtextdomain(PACKAGE, LOCALEDIR);
bindtextdomain("gnulib", GNULIB_LOCALEDIR);
textdomain(PACKAGE);
#endif

    init_localeinfo(&localeinfo);

    atexit(clean_up_stdout);
    c_stack_action(nullptr);

    last_recursive = 0;

    pattern_table = hash_initialize(0, 0, hash_pattern, compare_patterns, 0);
    if (!pattern_table)
        xalloc_die();

    while (prev_optind = optind,
           (opt = get_nondigit_option(argc, argv, &default_context)) != -1)
        switch (opt)
        {
        case 'A':
            context_length_arg(optarg, &out_after);
            break;

        case 'B':
            context_length_arg(optarg, &out_before);
            break;

        case 'C':
            /* Set output match context, but let any explicit leading or
               trailing amount specified with -A or -B stand. */
            context_length_arg(optarg, &default_context);
            break;

        case 'D':
            if (STREQ(optarg, "read"))
                devices = READ_DEVICES;
            else if (STREQ(optarg, "skip"))
                devices = SKIP_DEVICES;
            else
                die(EXIT_TROUBLE, 0, _("unknown devices method"));
            break;

        case 'E':
            matcher = setmatcher("egrep", matcher);
            break;

        case 'F':
            matcher = setmatcher("fgrep", matcher);
            break;

        case 'P':
            matcher = setmatcher("perl", matcher);
            break;

        case 'G':
            matcher = setmatcher("grep", matcher);
            break;

        case 'X': /* undocumented on purpose */
            matcher = setmatcher(optarg, matcher);
            break;

        case 'H':
            filename_option = 1;
            break;

        case 'I':
            binary_files = WITHOUT_MATCH_BINARY_FILES;
            break;

        case 'T':
            align_tabs = true;
            break;

        case 'U':
            if (O_BINARY)
                binary = true;
            break;

        case 'V':
            show_version = true;
            break;

        case 'a':
            binary_files = TEXT_BINARY_FILES;
            break;

        case 'b':
            out_byte = true;
            break;

        case 'c':
            count_matches = true;
            break;

        case 'd':
            directories = XARGMATCH("--directories", optarg,
                                    directories_args, directories_types);
            if (directories == RECURSE_DIRECTORIES)
                last_recursive = prev_optind;
            break;

        case 'e':
        {
            idx_t cc = strlen(optarg);
            ptrdiff_t shortage = keycc - keyalloc + cc + 1;
            if (0 < shortage)
                pattern_array = keys = xpalloc(keys, &keyalloc, shortage, -1, 1);
            char *keyend = mempcpy(keys + keycc, optarg, cc);
            *keyend = '\n';
            keycc = update_patterns(keys, keycc, keycc + cc + 1, "");
        }
        break;

        case 'f':
        {
            if (STREQ(optarg, "-"))
            {
                if (binary)
                    xset_binary_mode(STDIN_FILENO, O_BINARY);
                fp = stdin;
            }
            else
            {
                fp = fopen(optarg, binary ? "rb" : "r");
                if (!fp)
                    die(EXIT_TROUBLE, errno, "%s", optarg);
            }
            idx_t newkeycc = keycc, cc;
            for (;; newkeycc += cc)
            {
                ptrdiff_t shortage = newkeycc - keyalloc + 2;
                if (0 < shortage)
                    pattern_array = keys = xpalloc(keys, &keyalloc,
                                                   shortage, -1, 1);
                cc = fread(keys + newkeycc, 1, keyalloc - (newkeycc + 1), fp);
                if (cc == 0)
                    break;
            }
            int err = errno;
            if (!ferror(fp))
            {
                err = 0;
                if (fp == stdin)
                    clearerr(fp);
                else if (fclose(fp) != 0)
                    err = errno;
            }
            if (err)
                die(EXIT_TROUBLE, err, "%s", optarg);
            /* Append final newline if file ended in non-newline. */
            if (newkeycc != keycc && keys[newkeycc - 1] != '\n')
                keys[newkeycc++] = '\n';
            keycc = update_patterns(keys, keycc, newkeycc, optarg);
        }
        break;

        case 'h':
            filename_option = -1;
            break;

        case 'i':
        case 'y': /* For old-timers . . . */
            match_icase = true;
            break;

        case NO_IGNORE_CASE_OPTION:
            match_icase = false;
            break;

        case 'L':
            /* Like -l, except list files that don't contain matches.
               Inspired by the same option in Hume's gre. */
            list_files = LISTFILES_NONMATCHING;
            break;

        case 'l':
            list_files = LISTFILES_MATCHING;
            break;

        case 'm':
            switch (xstrtoimax(optarg, 0, 10, &max_count, ""))
            {
            case LONGINT_OK:
            case LONGINT_OVERFLOW:
                break;

            default:
                die(EXIT_TROUBLE, 0, _("invalid max count"));
            }
            break;

        case 'n':
            out_line = true;
            break;

        case 'o':
            only_matching = true;
            break;

        case 'q':
            exit_on_match = true;
            break;

        case 'R':
            fts_options = basic_fts_options | FTS_LOGICAL;
            FALLTHROUGH;
        case 'r':
            directories = RECURSE_DIRECTORIES;
            last_recursive = prev_optind;
            break;

        case 's':
            suppress_errors = true;
            break;

        case 'v':
            out_invert = true;
            break;

        case 'w':
            wordinit();
            match_words = true;
            break;

        case 'x':
            match_lines = true;
            break;

        case 'Z':
            filename_mask = 0;
            break;

        case 'z':
            eolbyte = '\0';
            break;

        case BINARY_FILES_OPTION:
            if (STREQ(optarg, "binary"))
                binary_files = BINARY_BINARY_FILES;
            else if (STREQ(optarg, "text"))
                binary_files = TEXT_BINARY_FILES;
            else if (STREQ(optarg, "without-match"))
                binary_files = WITHOUT_MATCH_BINARY_FILES;
            else
                die(EXIT_TROUBLE, 0, _("unknown binary-files type"));
            break;

        case COLOR_OPTION:
            if (optarg)
            {
                if (!c_strcasecmp(optarg, "always") || !c_strcasecmp(optarg, "yes") || !c_strcasecmp(optarg, "force"))
                    color_option = 1;
                else if (!c_strcasecmp(optarg, "never") || !c_strcasecmp(optarg, "no") || !c_strcasecmp(optarg, "none"))
                    color_option = 0;
                else if (!c_strcasecmp(optarg, "auto") || !c_strcasecmp(optarg, "tty") || !c_strcasecmp(optarg, "if-tty"))
                    color_option = 2;
                else
                    show_help = 1;
            }
            else
                color_option = 2;
            break;

        case EXCLUDE_OPTION:
        case INCLUDE_OPTION:
            for (int cmd = 0; cmd < 2; cmd++)
            {
                if (!excluded_patterns[cmd])
                    excluded_patterns[cmd] = new_exclude();
                add_exclude(excluded_patterns[cmd], optarg,
                            ((opt == INCLUDE_OPTION ? EXCLUDE_INCLUDE : 0) | exclude_options(cmd)));
            }
            break;
        case EXCLUDE_FROM_OPTION:
            for (int cmd = 0; cmd < 2; cmd++)
            {
                if (!excluded_patterns[cmd])
                    excluded_patterns[cmd] = new_exclude();
                if (add_exclude_file(add_exclude, excluded_patterns[cmd],
                                     optarg, exclude_options(cmd), '\n') != 0)
                    die(EXIT_TROUBLE, errno, "%s", optarg);
            }
            break;

        case EXCLUDE_DIRECTORY_OPTION:
            strip_trailing_slashes(optarg);
            for (int cmd = 0; cmd < 2; cmd++)
            {
                if (!excluded_directory_patterns[cmd])
                    excluded_directory_patterns[cmd] = new_exclude();
                add_exclude(excluded_directory_patterns[cmd], optarg,
                            exclude_options(cmd));
            }
            break;

        case GROUP_SEPARATOR_OPTION:
            group_separator = optarg;
            break;

        case LINE_BUFFERED_OPTION:
            line_buffered = true;
            break;

        case LABEL_OPTION:
            label = optarg;
            break;

        case 0:
            /* long options */
            break;

        default:
            usage(EXIT_TROUBLE);
            break;
        }

    if (show_version)
    {
        version_etc(stdout, getprogname(), PACKAGE_NAME, VERSION,
                    (char *)nullptr);
        puts(_("Written by Mike Haertel and others; see\n"
               "<https://git.savannah.gnu.org/cgit/grep.git/tree/AUTHORS>."));

#if HAVE_LIBPCRE
Pprint_version();
#endif
return EXIT_SUCCESS;
}

    if (show_help)
        usage(EXIT_SUCCESS);

    if (keys)
    {
        if (keycc == 0)
        {
            /* No keys were specified (e.g. -f /dev/null).  Match nothing.  */
            out_invert ^= true;
            match_lines = match_words = false;
            keys[keycc++] = '\n';
        }
    }
    else if (optind < argc)
    {
        /* If a command-line regular expression operand starts with '\-',
           skip the '\'.  This suppresses a stray-backslash warning if a
           script uses the non-POSIX "grep '\-x'" to avoid treating
           '-x' as an option.  */
        char const *pat = argv[optind++];
        bool skip_bs = (matcher != F_MATCHER_INDEX && pat[0] == '\\' && pat[1] == '-');

        /* Make a copy so that it can be reallocated or freed later.  */
        pattern_array = keys = xstrdup(pat + skip_bs);
        idx_t patlen = strlen(keys);
        keys[patlen] = '\n';
        keycc = update_patterns(keys, 0, patlen + 1, "");
    }
    else
        usage(EXIT_TROUBLE);

    /* Strip trailing newline from keys.  */
    keycc--;

    hash_free(pattern_table);

    bool possibly_tty = false;
    struct stat tmp_stat;
    if (!exit_on_match && fstat(STDOUT_FILENO, &tmp_stat) == 0)
    {
        if (S_ISREG(tmp_stat.st_mode))
            out_stat = tmp_stat;
        else if (S_ISCHR(tmp_stat.st_mode))
        {
            struct stat null_stat;
            if (stat("/dev/null", &null_stat) == 0 && SAME_INODE(tmp_stat, null_stat))
                dev_null_output = true;
            else
                possibly_tty = true;
        }
    }

    /* POSIX says -c, -l and -q are mutually exclusive.  In this
       implementation, -q overrides -l and -L, which in turn override -c.  */
    if (exit_on_match | dev_null_output)
        list_files = LISTFILES_NONE;
    if ((exit_on_match | dev_null_output) || list_files != LISTFILES_NONE)
    {
        count_matches = false;
        if (max_count == INTMAX_MAX)
            done_on_match = true;
    }
    out_quiet = count_matches | done_on_match | exit_on_match;

    if (out_after < 0)
        out_after = default_context;
    if (out_before < 0)
        out_before = default_context;

    /* If it is easy to see that matching cannot succeed (e.g., 'grep -f
       /dev/null'), fail without reading the input.  */
    if ((max_count == 0 || (keycc == 0 && out_invert && !match_lines && !match_words)) && list_files != LISTFILES_NONMATCHING)
        return EXIT_FAILURE;

    if (color_option == 2)
        color_option = possibly_tty && should_colorize() && isatty(STDOUT_FILENO);
    init_colorize();

    if (color_option)
    {
        /* Legacy.  */
        char *userval = getenv("GREP_COLOR");
        if (userval && *userval)
            for (char *q = userval; *q == ';' || c_isdigit(*q); q++)
                if (!q[1])
                {
                    selected_match_color = context_match_color = userval;
                    break;
                }

        /* New GREP_COLORS has priority.  */
        parse_grep_colors();

        /* Warn if GREP_COLOR has an effect, since it's deprecated.  */
        if (selected_match_color == userval || context_match_color == userval)
            error(0, 0, _("warning: GREP_COLOR='%s' is deprecated;"
                          " use GREP_COLORS='mt=%s'"),
                  userval, userval);
    }

    initialize_unibyte_mask();

    if (matcher < 0)
        matcher = G_MATCHER_INDEX;

    if (matcher == F_MATCHER_INDEX || matcher == E_MATCHER_INDEX || matcher == G_MATCHER_INDEX)
    {
        if (match_icase)
            setup_ok_fold();

        /* In a single-byte locale, switch from -F to -G if it is a single
           pattern that matches words, where -G is typically faster.  In a
           multibyte locale, switch if the patterns have an encoding error
           (where -F does not work) or if -i and the patterns will not work
           for -iF.  */
        if (matcher == F_MATCHER_INDEX)
        {
            if (!localeinfo.multibyte
                    ? n_patterns == 1 && match_words
                    : (contains_encoding_error(keys, keycc) || (match_icase && !fgrep_icase_available(keys, keycc))))
            {
                fgrep_to_grep_pattern(&pattern_array, &keycc);
                keys = pattern_array;
                matcher = G_MATCHER_INDEX;
            }
        }
        /* With two or more patterns, if -F works then switch from either -E
           or -G, as -F is probably faster then.  */
        else if (1 < n_patterns)
            matcher = try_fgrep_pattern(matcher, keys, &keycc);
    }

    execute = matchers[matcher].execute;
    compiled_pattern =
        matchers[matcher].compile(keys, keycc, matchers[matcher].syntax,
                                  only_matching | color_option);
    /* We need one byte prior and one after.  */
    char eolbytes[3] = {0, eolbyte, 0};
    idx_t match_size;
    skip_empty_lines = (!execute(compiled_pattern, eolbytes + 1, 1,
                                 &match_size, nullptr) == out_invert);

    int num_operands = argc - optind;
    out_file = (filename_option == 0 && num_operands <= 1
                    ? -(directories == RECURSE_DIRECTORIES)
                    : 0 <= filename_option);

    if (binary)
        xset_binary_mode(STDOUT_FILENO, O_BINARY);

    /* Prefer sysconf for page size, as getpagesize typically returns int.  */

#ifdef \_SC_PAGESIZE
long psize = sysconf(\_SC_PAGESIZE);
#else
long psize = getpagesize();
#endif
if (!(0 < psize && psize <= (IDX_MAX - uword_size) / 2))
abort();
pagesize = psize;
good_readsize = ALIGN_TO(GOOD_READSIZE_MIN, pagesize);
bufalloc = good_readsize + pagesize + uword_size;
buffer = ximalloc(bufalloc);

    if (fts_options & FTS_LOGICAL && devices == READ_COMMAND_LINE_DEVICES)
        devices = READ_DEVICES;

    char *const *files;
    if (0 < num_operands)
    {
        files = argv + optind;
    }
    else if (directories == RECURSE_DIRECTORIES && 0 < last_recursive)
    {
        static char *const cwd_only[] = {(char *)".", nullptr};
        files = cwd_only;
        omit_dot_slash = true;
    }
    else
    {
        static char *const stdin_only[] = {(char *)"-", nullptr};
        files = stdin_only;
    }

    bool status = true;
    do
        status &= grep_command_line_arg(*files++);
    while (*files);

    return errseen ? EXIT_TROUBLE : status;

}
generated by cgit v1.2.3(git 2.25.1)at 2026 - 04 - 12 07 : 43 : 21 + 0000
