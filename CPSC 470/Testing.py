from NeuralNetUtil import buildExamplesFromCarData,buildExamplesFromPenData
from NeuralNet import buildNeuralNet
from math import pow, sqrt

def average(argList):
    return sum(argList)/float(len(argList))

def stDeviation(argList):
    mean = average(argList)
    diffSq = [pow((val-mean),2) for val in argList]
    return sqrt(sum(diffSq)/len(argList))

penData = buildExamplesFromPenData()
def testPenData(hiddenLayers = [24]):
    return buildNeuralNet(penData, maxItr = 200, hiddenLayerList = hiddenLayers)

carData = buildExamplesFromCarData()
def testCarData(hiddenLayers = [16]):
    return buildNeuralNet(carData, maxItr = 200,hiddenLayerList = hiddenLayers)


# Additional Code for Extra Credit Question 7
training_examples = [
    ( [0, 0], [0] ),
    ( [0, 1], [1] ),
    ( [1, 0], [1] ),
    ( [1, 1], [0] )]

test_examples = [
    ( [0, 0], [0] ),
    ( [0, 1], [1] ),
    ( [1, 0], [1] ),
    ( [1, 1], [0] )]

xor_examples = (training_examples, test_examples)

xorData = xor_examples
def test_XOR_Data(hiddenLayers):
    return buildNeuralNet(xorData, maxItr = 500,hiddenLayerList = hiddenLayers)

accuracy0 = []
accuracy1 = []
accuracy10 = []
accuracy50 = []

avg0 = []
avg1 = []
avg10 = []
avg50 = []

sdev0 = []
sdev1 = []
sdev10 = []
sdev50 = []


for i in range(5):    
    accuracy0.append(test_XOR_Data([0])[1])
    avg0.append(test_XOR_Data([0])[1])
    sdev0.append(test_XOR_Data([0])[1])
    
for i in range(5):    
    accuracy1.append(test_XOR_Data([1])[1])
    avg1.append(test_XOR_Data([1])[1])
    sdev1.append(test_XOR_Data([1])[1])
    
for i in range(5):    
    accuracy10.append(test_XOR_Data([10])[1])
    avg10.append(test_XOR_Data([10])[1])
    sdev10.append(test_XOR_Data([10])[1])
    
for i in range(5):    
    accuracy50.append(test_XOR_Data([50])[1])
    avg50.append(test_XOR_Data([50])[1])
    sdev50.append(test_XOR_Data([50])[1])

# Print the values
print("Hidden Layers: 0")
print(average(avg0))
print(max(accuracy0))
print(stDeviation(sdev0))

print("Hidden Layers: 1")
print(average(avg1))
print(max(accuracy1))
print(stDeviation(sdev1))

print("Hidden Layers: 10")
print(average(avg10))
print(max(accuracy10))
print(stDeviation(sdev10))

print("Hidden Layers: 50")
print(average(avg50))
print(max(accuracy50))
print(stDeviation(sdev50))

# End of code for Extra Credit Question 7
    

# Question 5
accuracies_list_cars = []
accuracies_list_pens = []

for i in range(5):
    result_car = testCarData()
    accuracies_list_cars.append(result_car[1])
    
print("Average for carData")
print(average(accuracies_list_cars))
print("Standard deviation for carData")
print(stDeviation(accuracies_list_cars))
print("Max for carData")  
print(max(accuracies_list_cars))
    

for i in range(5):
    result_pen = testPenData()
    accuracies_list_pens.append(result_pen[1])

print("Average for penData")
print(average(accuracies_list_pens))
print("Standard deviation for penData")
print(stDeviation(accuracies_list_pens))
print("Max for penData")  
print(max(accuracies_list_pens))


# Question 6
def testCarDataQuestion6(hiddenLayers):
    return buildNeuralNet(carData, maxItr = 200,hiddenLayerList = hiddenLayers)

def testPenDataQuestion6(hiddenLayers):
    return buildNeuralNet(penData, maxItr = 200,hiddenLayerList = hiddenLayers)

def q6_car():
    max_accuracy0 = []
    max_accuracy5 = []
    max_accuracy10 = []
    max_accuracy15 = []
    max_accuracy20 = []
    max_accuracy25 = []
    max_accuracy30 = []
    max_accuracy35 = []
    max_accuracy40 = []

    total_maxaccuracy_list = [max_accuracy0,max_accuracy5,max_accuracy10,max_accuracy15,max_accuracy20,max_accuracy25,max_accuracy30,max_accuracy35,max_accuracy40]

    avg_accuracy0 = []
    avg_accuracy5 = []
    avg_accuracy10 = []
    avg_accuracy15 = []
    avg_accuracy20 = []
    avg_accuracy25 = []
    avg_accuracy30 = []
    avg_accuracy35 = []
    avg_accuracy40 = []

    total_avgaccuracy_list = [avg_accuracy0,avg_accuracy5,avg_accuracy10,avg_accuracy15,avg_accuracy20,avg_accuracy25,avg_accuracy30,avg_accuracy35,avg_accuracy40]

    sdev0 = []
    sdev5 = []
    sdev10 = []
    sdev15 = []
    sdev20 = []
    sdev25 = []
    sdev30 = []
    sdev35 = []
    sdev40 = []

    total_sdev_list = [sdev0,sdev5,sdev10,sdev15,sdev20,sdev25,sdev30,sdev35,sdev40]
    
    for i in range(5):
        list_tracker = 0
        for j in range(0,41,5):
            total_maxaccuracy_list[list_tracker].append(testCarDataQuestion6([j])[1])
            total_avgaccuracy_list[list_tracker].append(testCarDataQuestion6([j])[1])
            total_sdev_list[list_tracker].append(testCarDataQuestion6([j])[1])
            list_tracker += 1
    
    iteration_tracker = 0
    
    for list in total_maxaccuracy_list:
        print(iteration_tracker)
        print(max(list)) 
        print(average(list))
        print(stDeviation(list))
        iteration_tracker += 5 
        print()

def q6_pen():
    max_accuracy0 = []
    max_accuracy5 = []
    max_accuracy10 = []
    max_accuracy15 = []
    max_accuracy20 = []
    max_accuracy25 = []
    max_accuracy30 = []
    max_accuracy35 = []
    max_accuracy40 = []

    total_maxaccuracy_list = [max_accuracy0,max_accuracy5,max_accuracy10,max_accuracy15,max_accuracy20,max_accuracy25,max_accuracy30,max_accuracy35,max_accuracy40]

    avg_accuracy0 = []
    avg_accuracy5 = []
    avg_accuracy10 = []
    avg_accuracy15 = []
    avg_accuracy20 = []
    avg_accuracy25 = []
    avg_accuracy30 = []
    avg_accuracy35 = []
    avg_accuracy40 = []

    total_avgaccuracy_list = [avg_accuracy0,avg_accuracy5,avg_accuracy10,avg_accuracy15,avg_accuracy20,avg_accuracy25,avg_accuracy30,avg_accuracy35,avg_accuracy40]

    sdev0 = []
    sdev5 = []
    sdev10 = []
    sdev15 = []
    sdev20 = []
    sdev25 = []
    sdev30 = []
    sdev35 = []
    sdev40 = []

    total_sdev_list = [sdev0,sdev5,sdev10,sdev15,sdev20,sdev25,sdev30,sdev35,sdev40]
    
    for i in range(5):
        list_tracker = 0
        for j in range(0,41,5):
            total_maxaccuracy_list[list_tracker].append(testPenDataQuestion6([j])[1])
            total_avgaccuracy_list[list_tracker].append(testPenDataQuestion6([j])[1])
            total_sdev_list[list_tracker].append(testPenDataQuestion6([j])[1])
            list_tracker += 1
    
    iteration_tracker = 0
    
    for list in total_maxaccuracy_list:
        print(iteration_tracker)
        print(max(list)) 
        print(average(list))
        print(stDeviation(list))
        iteration_tracker += 5 
        print()
            
            
            
q6_car()
print()
q6_pen()
        
        
""" list_car = []
list_pen = []

def question6_car():
    res1 = buildNeuralNet(carData, maxItr = 200,hiddenLayerList = [0])[1]
    list_car.append(res1)
    
    res2 = buildNeuralNet(carData, maxItr = 200,hiddenLayerList = [5])[1]
    list_car.append(res2)
    
    res3 = buildNeuralNet(carData, maxItr = 200,hiddenLayerList = [10])[1]
    list_car.append(res3)
    
    res4 = buildNeuralNet(carData, maxItr = 200,hiddenLayerList = [15])[1]
    list_car.append(res4)
    
    res5 = buildNeuralNet(carData, maxItr = 200,hiddenLayerList = [20])[1]
    list_car.append(res5)
    
    res6=buildNeuralNet(carData, maxItr = 200,hiddenLayerList = [25])[1]
    list_car.append(res6)
    
    res7=buildNeuralNet(carData, maxItr = 200,hiddenLayerList = [30])[1]
    list_car.append(res7)
    
    res8=buildNeuralNet(carData, maxItr = 200,hiddenLayerList = [35])[1]
    list_car.append(res8)
    
    res9=buildNeuralNet(carData, maxItr = 200,hiddenLayerList = [40])[1]
    list_car.append(res9)
    
    print("Average for carData")
    print(average(list_car))
    print("Standard deviation for carData")
    print(stDeviation(list_car))
    print("Max for carData")  
    print(max(list_car))
    
def question6_pen():
    res1 = buildNeuralNet(penData, maxItr = 200,hiddenLayerList = [0])[1]
    list_pen.append(res1)
    
    res2=buildNeuralNet(penData, maxItr = 200,hiddenLayerList = [5])[1]
    list_pen.append(res2)
    
    res3=buildNeuralNet(penData, maxItr = 200,hiddenLayerList = [10])[1]
    list_pen.append(res3)
    
    res4=buildNeuralNet(penData, maxItr = 200,hiddenLayerList = [15])[1]
    list_pen.append(res4)
    
    res5=buildNeuralNet(penData, maxItr = 200,hiddenLayerList = [20])[1]
    list_pen.append(res5)
    
    res6=buildNeuralNet(penData, maxItr = 200,hiddenLayerList = [25])[1]
    list_pen.append(res6)
    
    res7=buildNeuralNet(penData, maxItr = 200,hiddenLayerList = [30])[1]
    list_pen.append(res7)
    
    res8=buildNeuralNet(penData, maxItr = 200,hiddenLayerList = [35])[1]
    list_pen.append(res8)
    
    res9=buildNeuralNet(penData, maxItr = 200,hiddenLayerList = [40])[1]
    list_pen.append(res9)
    
    print("Average for penData")
    print(average(list_pen))
    print("Standard deviation for penData")
    print(stDeviation(list_pen))
    print("Max for penData")  
    print(max(list_pen))
    
print("Car Data for Question 6")
for i in range(5):
    print(f"Iteration {i}")
    question6_car()
    
print("Pen Data for Question 6")
for i in range(5):
    print(f"Iteration {i}")
    question6_pen()
 """