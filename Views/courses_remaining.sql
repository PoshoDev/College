CREATE	VIEW courses_remaining AS
SELECT	DISTINCT id, name, credits
FROM	course
WHERE	id NOT IN (
    		SELECT	course
    		FROM	class
    	);