CREATE		VIEW courses_passed AS
SELECT		course.id, class.crn,
			course.name, class.grade_final
FROM		course, class, period
WHERE		course.id=class.course
			AND class.period=period.name
			AND class.grade_final>=70
ORDER BY	period.start ASC;