local Sapnet = {}

math.randomseed(os.time())

Sapnet.Neuron = {}
Sapnet.Neuron.__index = Sapnet.Neuron

Sapnet.Brain = {}
Sapnet.Brain.__index = Sapnet.Brain

if not math.tanh then
    function math.tanh(x)
        return (math.exp(x) - math.exp(-x)) / (math.exp(x) + math.exp(-x))
    end
end

Sapnet.Operations = {
    math.sin,
    math.cos,
    math.tan,
    function(x) return 1 / (1 + math.exp(-x)) end,
    function(x) return math.max(0, x) end,
    math.tanh,
    function(x) return x end,
}

function Sapnet.Neuron:newRandom(inputs)
    return setmetatable({
            operation = math.random(1, #Sapnet.Operations),
            weight = math.random(0.0, 2.0),
            bias = math.random(0.0, 2.0),
            inputs = inputs,
            output = 0
        },

        self
    )
end

function Sapnet.Neuron:mutateRandom(mutationrate)
    if math.random(1, 20) == 1 then
        self.operation = math.random(1, #Sapnet.Operations)
    end
    self.weight = math.min(math.max(self.weight + (math.random() * (mutationrate / 10)) * math.random(-1, 1), -2), 2)
    self.bias = math.min(math.max(self.bias + (math.random() * (mutationrate / 10)) * math.random(-1, 1), -5), 5)
end

function Sapnet.Neuron:updateNeuron(inputs)
    self.inputs = inputs
    local inny = self.inputs

    local temp = 0
    for i = 1, #inny do
        temp = temp + inny[i].output
    end
    temp = temp * self.weight
    temp = temp + self.bias
    temp = Sapnet.Operations[self.operation](temp)
    self.output = temp
end

function Sapnet.Brain:newRandom(inamount, npl, hiddenlayers, outamount)
    local layers = {}
    local inputtable = {}
    local outputtable = {}
    for i = 1, inamount do
        inputtable[i] = { output = 0 }
    end
    for i = 1, outamount do
        outputtable[i] = Sapnet.Neuron:newRandom(layers[#layers])
    end
    for i = 1, hiddenlayers do
        layers[i] = {}
        for j = 1, npl do
            layers[i][j] = Sapnet.Neuron:newRandom(layers[i - 1] or inputtable)
        end
    end
    return setmetatable({ layers = layers, inputs = inputtable, outputs = outputtable }, self)
end

function Sapnet.Brain:updateNeurons()
    for i = 1, #self.layers do
        for j = 1, #self.layers[i] do
            local curneur = self.layers[i][j]
            curneur:updateNeuron(self.layers[i - 1] or self.inputs)
        end
    end
    for i = 1, #self.outputs do
        local curneur = self.outputs[i]
        if #self.layers > 0 then
            curneur:updateNeuron(self.layers[#self.layers])
        else
            curneur:updateNeuron(self.inputs)
        end
    end
end

function Sapnet.Brain:mutateRandom(mutationrate)
    for i = 1, #self.layers do
        for j = 1, #self.layers[i] do
            local curneur = self.layers[i][j]
            curneur:mutateRandom(mutationrate)
        end
    end
end

function Sapnet.Brain:input(i, v)
    self.inputs[i] = { output = v }
end

function Sapnet.Brain:getOutput(i)
    return self.outputs[i]
end

function Sapnet.Brain:empty()
    for i = 1, #self.layers do
        for j = 1, #self.layers[i] do
            local curneur = self.layers[i][j]
            curneur.output = 0
        end
    end
    for i = 1, #self.inputs do
        self.inputs[i].output = 0
    end
end

-- local smart = Sapnet.Brain:newRandom(2, 3, 1, 2)
-- smart:input(1, 4)
-- smart:input(2, 7)
-- smart:updateNeurons()
-- for i = 1, 2 do
--     print(smart:getOutput(i).output)
-- end

function Sapnet.Brain:encode(lib)
    local networkData = {
        layers = self.layers,
        inputs = self.inputs,
        outputs = self.outputs,
    }
    return lib.encode(networkData)
end

function Sapnet.Brain:decode(lib, data)
    return lib.decode(data)
end

return Sapnet
