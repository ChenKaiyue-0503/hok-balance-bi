-- 1. 各时间段的胜方平均经济差
SELECT 
    time AS 游戏时间_分钟,
    ROUND(AVG(gold_diff), 0) AS 胜方平均经济差,
    ROUND(AVG(kill_diff), 2) AS 胜方平均击杀差
FROM 
    game_time_slices
GROUP BY 
    time
ORDER BY 
    time;

-- 2. 异常局筛查：10分钟节点严重滚雪球对局
WITH Stats AS (
    SELECT 
        AVG(gold_diff) AS mean_gold,
        STDDEV(gold_diff) AS sd_gold
    FROM game_time_slices
    WHERE time = 10.0
)
SELECT 
    game_id AS 对局ID,
    gold_diff AS 十分钟经济差,
    ROUND((SELECT mean_gold FROM Stats), 0) AS 平均经济差,
    ROUND((SELECT sd_gold FROM Stats), 0) AS 标准差,
    '严重滚雪球' AS 标签
FROM 
    game_time_slices, Stats
WHERE 
    time = 10.0 
    AND gold_diff > (mean_gold + 1.5 * sd_gold)
ORDER BY 
    gold_diff DESC;