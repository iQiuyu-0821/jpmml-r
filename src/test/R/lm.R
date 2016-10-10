source("util.R")

auto = loadAutoCsv("Auto")

generateLinearRegressionFormulaAuto = function(){
	auto.lm = lm(mpg ~ ., data = auto)
	print(auto.lm)

	mpg = predict(auto.lm, newdata = auto)

	storeRds(auto.lm, "LinearRegressionFormulaAuto")
	storeCsv(data.frame("mpg" = mpg), "LinearRegressionFormulaAuto")
}

generateLinearRegressionRichFormulaAuto = function(){
	auto.lm = lm(mpg ~ (.) ^ 2, data = auto)
	print(auto.lm)

	mpg = predict(auto.lm, newdata = auto)

	storeRds(auto.lm, "LinearRegressionCustFormulaAuto")
	storeCsv(data.frame("mpg" = mpg), "LinearRegressionCustFormulaAuto")
}

generateLinearRegressionFormulaAuto()
generateLinearRegressionRichFormulaAuto()

wine_quality = loadWineQualityCsv("WineQuality")

generateLinearRegressionFormulaWineQuality = function(){
	wine_quality.lm = lm(quality ~ ., data = wine_quality)
	print(wine_quality.lm)

	quality = predict(wine_quality.lm, newdata = wine_quality)

	storeRds(wine_quality.lm, "LinearRegressionFormulaWineQuality")
	storeCsv(data.frame("quality" = quality), "LinearRegressionFormulaWineQuality")
}

generateLinearRegressionFormulaWineQuality()