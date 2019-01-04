#include "optimizer.h"

#include <iostream>
#include <math.h>

Optimizer::Optimizer() : QObject() {
    // TODO: initialization list?
    best_target_value = INFINITY;
    initialized = false;
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
            .def("addOptimizationValues", &Optimizer::addOptimizationValues)
            .def("setTargetFunction", &Optimizer::setTargetFunction)
            .def("getOptimizationValue", &Optimizer::getOptimizationValue)
            ];
}

void Optimizer::addOptimizationValues(
    const std::string name, 
    const luabind::object& min_value_object, 
    const luabind::object& max_value_object, 
    const luabind::object& step_object 
) {
    // TODO: set default step to 1?
    // TODO: ORR - you are welcome to add a type check "for good practice"
    // TODO: We need this initialize because hasNextOptimizationValue is run before
    // the optimization_values are first set but it prevents a user from not optimizing by default.
    initialized = true;
    int min_value = luabind::object_cast<int>(min_value_object);
    int max_value = luabind::object_cast<int>(max_value_object);
    int step = luabind::object_cast<int>(step_object);
    if (optimization_values.find(name) == optimization_values.end()) {
	optimization_values[name] = std::make_tuple(min_value, max_value, step);
	current_optimization_values[name] = min_value;
	best_optimization_values[name] = min_value;
    }
    int f = std::get<0>(optimization_values[name]);
    int s = std::get<1>(optimization_values[name]);
    int t = std::get<2>(optimization_values[name]);
    std::cout << name << f << s << t << std::endl; 
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
		for (
		    auto it = current_optimization_values.begin();
		    it != current_optimization_values.end();
		    it++
		) {
		    best_optimization_values[it->first] = it->second;
		}
	    }
        } catch(const std::exception& e){
            //FIXME: Call this function from viewer, or else on error the stack would go nuts
            //showLuaException(e, "Optimization Target Function exception");
        }
    }
    //TODO: Throw an error
}

int Optimizer::getOptimizationValue(std::string name) {
    if (hasNextOptimizationValue()) {
	return current_optimization_values[name]; 
    }
    return getBestOptimizationValue(name);
}



void Optimizer::advanceOptimizationValue() {
    for (
	auto it = current_optimization_values.begin();
	it != current_optimization_values.end();
	it++
    ) {
	auto range = optimization_values[it->first];
	int min_value = std::get<0>(range);
	int max_value = std::get<1>(range);
	int step = std::get<2>(range);
	if (it->second + step <= max_value) {
	    it->second += step;
	    return;
	}
	it->second = min_value;
    }
}

bool Optimizer::hasNextOptimizationValue() {
    std::cout << "Started function" << std::endl;
    for (
	auto it = current_optimization_values.begin();
	it != current_optimization_values.end();
	it++
    ) {
	auto range = optimization_values[it->first];
	int end = std::get<1>(range);
	int step = std::get<2>(range);
	std::cout << "At " << it->first << " we got " << it->second << " when the end is at " << end << " when walking in steps of " << step << std::endl;
	if (it->second + step <= end) {
    	    std::cout << "Returned True from function" << std::endl;
	    return true;
	}
    }
    std::cout << "Returned False and ended function" << std::endl;
    return false;
}

int Optimizer::getBestOptimizationValue(std::string name) {
    return best_optimization_values[name];
}
float Optimizer::getBestTargetValue() {
    return best_target_value;
}
