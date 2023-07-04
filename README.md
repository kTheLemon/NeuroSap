# NeuroSap
A lua library for neural networks.

## Neuron

### newRandom(inputs)
Returns a new random neuron. The argument really doesn't matter.

### mutateRandom()
Randomly mutates a neuron.

### updateNeuron(inputs)
Updates the neuron based on the given inputs and sets its output.

## Brain

### newRandom(inamount, npl, hiddenlayers, outamount)
Creates a new linear neural network.
- inamount : specifies the amount of inputs the brain has.
- npl : the amount of neurons per hidden layer.
- hiddenlayers : the amount of hidden layers.
- outamount : the amount of outputs.

### mutateRandom()
Randomly mutates a neural network.

### input(i, v)
Inputs the specified value into a neural network at the specified index. Inputs are kept until the neural network is emptied.

### getOutput(i)
Returns the output of a neural network at the specified index.

### updateNeurons()
Updates a neural network based on its current inputs.

### empty()
Resets all the neurons in a neural network.

### encode(lib)
Returns the encoded string of a neural network in the specified library. Make sure the library has an encode function!

### decode(lib, data)
Returns the decoded version of an encoded neural network in the specified library. Make sure the library has a decode function!
