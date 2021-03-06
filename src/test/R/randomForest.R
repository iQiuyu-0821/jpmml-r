library("caret")
library("randomForest")

source("util.R")

audit = loadAuditCsv("Audit")

audit_x = audit[, -ncol(audit)]
audit_y = audit[, ncol(audit)]

predictRandomForestAudit = function(audit.randomForest, data, targetName){
	adjusted = predict(audit.randomForest, newdata = data)
	probabilities = predict(audit.randomForest, newdata = data, type = "prob")

	result = data.frame("y" = adjusted, "probability_0" = probabilities[, 1], "probability_1" = probabilities[, 2])
	names(result) = gsub("^y$", targetName, names(result))

	return (result)
}

generateRandomForestFormulaAudit = function(){
	audit.randomForest = randomForest(Adjusted ~ ., data = audit, ntree = 7)
	print(audit.randomForest)

	storeRds(audit.randomForest, "RandomForestFormulaAudit")
	storeCsv(predictRandomForestAudit(audit.randomForest, audit, "Adjusted"), "RandomForestFormulaAudit")
}

generateRandomForestAudit = function(){
	audit.randomForest = randomForest(x = audit_x, y = audit_y, ntree = 7)
	print(audit.randomForest)

	storeRds(audit.randomForest, "RandomForestAudit")
	storeCsv(predictRandomForestAudit(audit.randomForest, audit_x, "_target"), "RandomForestAudit")
}

set.seed(42)

generateRandomForestFormulaAudit()
generateRandomForestAudit()

generateTrainRandomForestFormulaAuditMatrix = function(){
	audit.train = train(Adjusted ~ ., data = audit, method = "rf", ntree = 7)
	print(audit.train)

	adjusted = predict(audit.train, newdata = audit)

	storeRds(audit.train, "TrainRandomForestFormulaAuditMatrix")
	storeCsv(data.frame("_target" = adjusted), "TrainRandomForestFormulaAuditMatrix")
}

generateTrainRandomForestAudit = function(){
	audit.train = train(x = audit_x, y = audit_y, method = "rf", ntree = 7)
	print(audit.train)

	adjusted = predict(audit.train, newdata = audit_x)

	storeRds(audit.train, "TrainRandomForestAudit")
	storeCsv(data.frame("_target" = adjusted), "TrainRandomForestAudit")
}

set.seed(42)

generateTrainRandomForestFormulaAuditMatrix()
generateTrainRandomForestAudit()

auto = loadAutoCsv("Auto")

auto_x = auto[, -ncol(auto)]
auto_y = auto[, ncol(auto)]

generateRandomForestFormulaAuto = function(){
	auto.randomForest = randomForest(mpg ~ ., data = auto, ntree = 7)
	print(auto.randomForest)

	mpg = predict(auto.randomForest, newdata = auto)

	storeRds(auto.randomForest, "RandomForestFormulaAuto")
	storeCsv(data.frame("mpg" = mpg), "RandomForestFormulaAuto")
}

generateRandomForestAuto = function(){
	auto.randomForest = randomForest(x = auto_x, y = auto_y, ntree = 7)
	print(auto.randomForest)

	mpg = predict(auto.randomForest, newdata = auto_x)

	storeRds(auto.randomForest, "RandomForestAuto")
	storeCsv(data.frame("_target" = mpg), "RandomForestAuto")
}

set.seed(42)

generateRandomForestFormulaAuto()
generateRandomForestAuto()

auto.caret = auto
auto.caret$origin = as.integer(auto.caret$origin)

generateTrainRandomForestFormulaAuto = function(){
	auto.train = train(mpg ~ ., data = auto.caret, method = "rf", ntree = 7)
	print(auto.train)

	mpg = predict(auto.train, newdata = auto.caret)

	storeRds(auto.train, "TrainRandomForestFormulaAuto")
	storeCsv(data.frame("_target" = mpg), "TrainRandomForestFormulaAuto")
}

generateTrainRandomForestAuto = function(){
	auto.train = train(x = auto_x, y = auto_y, method = "rf", ntree = 7)
	print(auto.train)

	mpg = predict(auto.train, newdata = auto_x)

	storeRds(auto.train, "TrainRandomForestAuto")
	storeCsv(data.frame("_target" = mpg), "TrainRandomForestAuto")
}

set.seed(42)

generateTrainRandomForestFormulaAuto()
generateTrainRandomForestAuto()

iris = loadIrisCsv("Iris")

iris_x = iris[, -ncol(iris)]
iris_y = iris[, ncol(iris)]

predictRandomForestIris = function(iris.randomForest, data, targetName){
	species = predict(iris.randomForest, newdata = data)
	probabilities = predict(iris.randomForest, newdata = data, type = "prob")

	result = data.frame("y" = species, "probability_setosa" = probabilities[, 1], "probability_versicolor" = probabilities[, 2], "probability_virginica" = probabilities[, 3])
	names(result) = gsub("^y$", targetName, names(result))

	return (result)
}

generateRandomForestFormulaIris = function(){
	iris.randomForest = randomForest(Species ~ ., data = iris, ntree = 7)
	print(iris.randomForest)

	storeRds(iris.randomForest, "RandomForestFormulaIris")
	storeCsv(predictRandomForestIris(iris.randomForest, iris, "Species"), "RandomForestFormulaIris")
}

generateRandomForestCustFormulaIris = function(){
	iris.randomForest = randomForest(Species ~ . - Sepal.Length, data = iris, ntree = 7)
	print(iris.randomForest)

	storeRds(iris.randomForest, "RandomForestCustFormulaIris")
	storeCsv(predictRandomForestIris(iris.randomForest, iris, "Species"), "RandomForestCustFormulaIris")
}

generateRandomForestIris = function(){
	iris.randomForest = randomForest(x = iris_x, y = iris_y, ntree = 7)
	print(iris.randomForest)

	storeRds(iris.randomForest, "RandomForestIris")
	storeCsv(predictRandomForestIris(iris.randomForest, iris_x, "_target"), "RandomForestIris")
}

set.seed(42)

generateRandomForestFormulaIris()
generateRandomForestCustFormulaIris()
generateRandomForestIris()

generateTrainRandomForestIris = function(){
	iris.train = train(x = iris_x, y = iris_y, method = "rf", preProcess = c("range"), ntree = 7)
	print(iris.train)

	storeRds(iris.train, "TrainRandomForestIris")
	storeCsv(predictRandomForestIris(iris.train, iris_x, "_target"), "TrainRandomForestIris")
}

generateTrainRandomForestFormulaIris = function(){
	iris.train = train(Species ~ ., data = iris, method = "rf", preProcess = c("center", "scale"), ntree = 7)
	print(iris.train)

	storeRds(iris.train, "TrainRandomForestFormulaIris")
	storeCsv(predictRandomForestIris(iris.train, iris, "_target"), "TrainRandomForestFormulaIris")
}

set.seed(42)

generateTrainRandomForestFormulaIris()
generateTrainRandomForestIris()

wine_quality = loadWineQualityCsv("WineQuality")

wine_quality_x = wine_quality[, -ncol(wine_quality)]
wine_quality_y = wine_quality[, ncol(wine_quality)]

generateRandomForestFormulaWineQuality = function(){
	wine_quality.randomForest = randomForest(quality ~ ., data = wine_quality, ntree = 7)
	print(wine_quality.randomForest)

	quality = predict(wine_quality.randomForest, newdata = wine_quality)

	storeRds(wine_quality.randomForest, "RandomForestFormulaWineQuality")
	storeCsv(data.frame("quality" = quality), "RandomForestFormulaWineQuality")
}

generateRandomForestWineQuality = function(){
	wine_quality.randomForest = randomForest(x = wine_quality_x, y = wine_quality_y, ntree = 7)
	print(wine_quality.randomForest)

	quality = predict(wine_quality.randomForest, newdata = wine_quality_x)

	storeRds(wine_quality.randomForest, "RandomForestWineQuality")
	storeCsv(data.frame("_target" = quality), "RandomForestWineQuality")
}

set.seed(42)

generateRandomForestFormulaWineQuality()
generateRandomForestWineQuality()

wine_color = loadWineColorCsv("WineColor")

wine_color_x = wine_color[, -ncol(wine_color)]
wine_color_y = wine_color[, ncol(wine_color)]

predictRandomForestWineColor = function(wine_color.randomForest, data, targetName){
	color = predict(wine_color.randomForest, newdata = wine_color)
	probabilities = predict(wine_color.randomForest, newdata = wine_color, type = "prob")

	result = data.frame("y" = color, "probability_red" = probabilities[, 1], "probability_white" = probabilities[, 2])
	names(result) = gsub("^y$", targetName, names(result))

	return (result)
}

generateRandomForestFormulaWineColor = function(){
	wine_color.randomForest = randomForest(color ~ ., data = wine_color, ntree = 7)
	print(wine_color.randomForest)

	storeRds(wine_color.randomForest, "RandomForestFormulaWineColor")
	storeCsv(predictRandomForestWineColor(wine_color.randomForest, wine_color, "color"), "RandomForestFormulaWineColor")
}

generateRandomForestWineColor = function(){
	wine_color.randomForest = randomForest(x = wine_color_x, y = wine_color_y, ntree = 7)
	print(wine_color.randomForest)

	storeRds(wine_color.randomForest, "RandomForestWineColor")
	storeCsv(predictRandomForestWineColor(wine_color.randomForest, wine_color_x, "_target"), "RandomForestWineColor")
}

set.seed(42)

generateRandomForestFormulaWineColor()
generateRandomForestWineColor()
