
SELECT *  FROM
(
    SELECT * FROM
    (
        SELECT USERID, NAME_KOR, DEPT_CD, PRIV, A.GRADE, DESCR, STDTIME, EOT, POSITION FROM HITEMS_USER A, HITEMS_USER_GRADE B
        WHERE GUNMU = 'I' 
        AND A.GRADE = B.GRADE
    ) A,
    (
        SELECT * FROM
        (
            SELECT RST_NO, RST_BY, RST_TITLE, RST_PERFORM, A.PLAN_NO, B.ENG_MODEL, B.ENG_TYPE, B.ENG_PROJNO FROM
            (
                SELECT * FROM
                (
                    SELECT MIN(RST_NO) MRN, RST_BY  FROM
                    (
                        SELECT  A.RST_NO, RST_BY, RST_TITLE FROM TMS_RESULT A, TMS_RESULT_MH B 
                        WHERE A.RST_NO = B.RST_NO
                        AND RST_TIME_TYPE = 1
                        AND RST_PERFORM = '2013-09-26'
                    )GROUP BY RST_BY
                ) A LEFT OUTER JOIN TMS_RESULT B
                ON A.MRN = B.RST_NO
            ) A, TMS_PLAN B
            WHERE A.PLAN_NO = B.PLAN_NO
        ) A LEFT OUTER JOIN 
        (
            SELECT RST_BY RB, SUM(RST_MH) MH FROM TMS_RESULT A, TMS_RESULT_MH B
            WHERE A.RST_NO = B.RST_NO
            AND RST_TIME_TYPE = 1
            AND RST_PERFORM = '2013-09-26'
            GROUP BY RST_BY
        ) B
        ON A.RST_BY = B.RB
    ) B
    WHERE A.USERID = B.RST_BY
)
         


 
     


