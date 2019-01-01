#include "optimizer.h"

#include <math.h>

Optimizer::Optimizer() : QObject() {
    // TODO: initialization list?
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

void Optimizer::addOptimizationValues(
    const luabind::object& name, 
    const luabind::object& min_value, 
    const luabind::object& max_value, 
    const luabind::object& step 
) {
    // #TODO: set default step to 1?
    // #TODO: ORR - you are welcome to add a type check "for good practice"
    if (self.optimization_values.find(name) == self.optimization_values.end()) {
	self.optimization_values[name] = std::tuple(min_value, max_value, step);
	self.current_optimization_values[name] = min_value;
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
    for (
	auto it = self.current_optimization_values.begin();
	it != self.current_optimization_values.end();
	it++
    ) {
	range = self.optimization_value[it->first];
	min_value = std::get<0>(range);
	max_value = std::get<1>(range);
	step = std::get<2>(range);
	if (it->second + step <= max_value) {
	    it->second += step;
	    return;
	}
	it->second = min_value;
    }
}

bool Optimizer::hasNextOptimizationValue() {
    for (
	auto it = self.current_optimization_values.begin();
	it != self.current_optimization_values.end();
	it++
    ) {
	range = self.optimization_value[it->first];
	end = std::get<1>(range);
	step = std::get<2>(range);
	if (it->second + step <= end) {
	    return true;
	}
    }
    return false;
}

int Optimizer::getBestOptimizationValue() {
    return best_optimization_value;
}
float Optimizer::getBestTargetValue() {
    return best_target_value;
}
