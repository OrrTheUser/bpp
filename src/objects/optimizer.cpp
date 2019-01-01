#include "optimizer.h"

#include <math.h>
#include <luabind/adopt_policy.hpp>

Optimizer::Optimizer() : QObject() {
    // TODO: initialization list?
    optimization_index = 0;
    best_optimization_value = 0;
    best_target_value = INFINITY;
}

Optimizer::~Optimizer() {
    // Left blank intentionally.
}

void Optimizer::luaBind(lua_State *s) {
    using namespace luabind;

    open(s);

    module(s)
            [
            class_<Optimizer>("Optimizer")
            .def(constructor<>())
            .def("setOptimizationValues", &Optimizer::setOptimizationValues)
            .def("setTargetFunction", &Optimizer::setTargetFunction)
            .property("optimization_value", &Optimizer::getOptimizationValue)
            ];
}

void Optimizer::setOptimizationValues(std::vector<int> optimization_values) {
    // #TODO: ORR - you are welcome to add a type check "for good practice"
    if (this->optimization_values == std::vector<int>()) {
	this->optimization_values = optimization_values;
    }
    else if (this->optimization_values != optimization_values) {
    	// TODO: this is bad, throw?
    }
}

void Optimizer::setTargetFunction(const luabind::object &fn) {
    // TODO: change the name of the target function member
    if(luabind::type(fn) == LUA_TFUNCTION) {
        _cb_targetFunc = fn;
    }
}

void Optimizer::callTargetFunction(){
    // TODO: verify optimization values was initiated as well (here and elsewhere)
    if(_cb_targetFunc) {
        try {
            float res = luabind::call_function<float>(_cb_targetFunc);
            if (best_target_value > res) {
		best_target_value = res;
		best_optimization_value = getOptimizationValue();
	    }
        } catch(const std::exception& e){
            //FIXME: Call this function from viewer, or else on error the stack would go nuts
            //showLuaException(e, "Optimization Target Function exception");
        }
    }
    //TODO: Throw an error
}

int Optimizer::getOptimizationValue() {
    if (hasNextOptimizationValue()) {
	return optimization_values[optimization_index]; 
    }
    return getBestOptimizationValue();
}

void Optimizer::advanceOptimizationValue() {
    optimization_index += 1;
}

bool Optimizer::hasNextOptimizationValue() {
    return optimization_index + 1 < optimization_values.size();
}

int Optimizer::getBestOptimizationValue() {
    return best_optimization_value;
}
float Optimizer::getBestTargetValue() {
    return best_target_value;
}
