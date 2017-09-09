SELECT * FROM TMS_TASK;
SELECT * FROM TMS_PLAN;

SELECT * FROM TMS_TASK_SHARE;

SELECT A.TASK_NO, TASK_PRT, TASK_ORDER, TASK_NAME, '' ENG_MODEL, '' ENG_TYPE, '' ENG_PROJNO, TASK_MANAGER, TASK_TEAM  FROM TMS_TASK A, TMS_TASK_SHARE B
WHERE A.TASK_NO = B.TASK_NO;


  

SELECT * FROM 
(
    SELECT A.TASK_NO, TASK_PRT, TASK_ORDER, TASK_NAME, 'T'TYPE FROM TMS_TASK A, TMS_TASK_SHARE B
    WHERE A.TASK_NO = B.TASK_NO 
    AND B.TASK_TEAM LIKE :DEPT_CD
    AND 
    (
        (
            TO_CHAR(EXD_TASK_START, 'yyyy-mm-dd') <= :beginDate 
            AND EXD_TASK_END >= TO_DATE(:beginDate, 'yyyy-mm-dd') 
            AND TO_CHAR(EXD_TASK_START, 'yyyy-mm-dd') <= :endDate 
            AND TO_CHAR(EXD_TASK_END, 'yyyy-mm-dd') <= :endDate 
            OR EXD_TASK_START >= TO_DATE(:beginDate, 'yyyy-mm-dd') 
            AND TO_CHAR(EXD_TASK_END, 'yyyy-mm-dd') >= :beginDate 
            AND TO_CHAR(EXD_TASK_START, 'yyyy-mm-dd') <= :endDate 
            AND TO_CHAR(EXD_TASK_END, 'yyyy-mm-dd') <= :endDate 
            OR TO_CHAR(EXD_TASK_START, 'yyyy-mm-dd') >= :beginDate 
            AND TO_CHAR(EXD_TASK_END, 'yyyy-mm-dd') >= :beginDate 
            AND TO_CHAR(EXD_TASK_START, 'yyyy-mm-dd') <= :endDate 
            AND TO_CHAR(EXD_TASK_END, 'yyyy-mm-dd') >= :endDate 
            OR TO_CHAR(EXD_TASK_START, 'yyyy-mm-dd') <= :beginDate 
            AND TO_CHAR(EXD_TASK_END, 'yyyy-mm-dd') >= :beginDate 
            AND TO_CHAR(EXD_TASK_START, 'yyyy-mm-dd') <= :endDate 
            AND TO_CHAR(EXD_TASK_END, 'yyyy-mm-dd') >= :endDate
        ) OR 
        (
            (EXD_TASK_START IS NULL) OR (EXD_TASK_END IS NULL)
        )
    ) UNION ALL
    SELECT PLAN_NO, TASK_NO, PRN, PLAN_NAME, 'P' TYPE FROM
    (
        SELECT A.PLAN_NO, TASK_NO, A.PRN, PLAN_NAME, ENG_MODEL, ENG_TYPE, ENG_PROJNO, PLAN_EMPNO, PLAN_TEAM FROM
        (            
            SELECT A.PLAN_NO, PRN, TASK_NO, PLAN_CODE, PLAN_TYPE, PLAN_NAME, ENG_MODEL, ENG_TYPE, ENG_PROJNO, PLAN_DRAFTER FROM
            (
                SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN GROUP BY PLAN_NO
            ) A JOIN 
            (
                SELECT * FROM TMS_PLAN
            )B
            ON A.PLAN_NO = B.PLAN_NO
            AND A.PRN = B.PLAN_REV_NO
        ) A JOIN
        (
            SELECT A.PLAN_NO, PRN, PLAN_EMPNO, PLAN_TEAM FROM
            (
                SELECT PLAN_NO, MAX(PLAN_REV_NO) PRN FROM TMS_PLAN GROUP BY PLAN_NO
            ) A JOIN 
            (
                SELECT * FROM TMS_PLAN_INCHARGE
            )B
            ON A.PLAN_NO = B.PLAN_NO
            AND A.PRN = B.PLAN_REV_NO
        ) B
        ON A.PLAN_NO = B.PLAN_NO
        AND A.PRN = B.PRN
    ) 
    WHERE ENG_MODEL LIKE :ENG_MODEL 
    AND ENG_TYPE LIKE :ENG_TYPE
    AND ENG_PROJNO LIKE :ENG_PROJNO
    AND PLAN_TEAM LIKE :DEPT_CD
    AND PLAN_EMPNO LIKE :USERID
    GROUP BY PLAN_NO, TASK_NO, PRN, PLAN_NAME
) 
START WITH TASK_PRT IS NULL
CONNECT BY PRIOR TASK_NO = TASK_PRT
ORDER SIBLINGS BY TASK_ORDER;     


  