#include "optimizer.h"

#include <math.h>
#include <luabind/adopt_policy.hpp>

Optimizer::Optimizer(
    std::vector<int> optimization_values
) : QObject() {
    // Initialize all the static values if the vector is empty
    // because that means they are uninitialized
    if (Optimizer::optimization == std::vector<int>()) {
	Optimizer::optimization = optimization_values;
	Optimizer::optimization_index = 0;
	Optimizer::best_index = 0;
	Optimizer::best_value = INFINITY;
    }
    else if (optimization_values != Optimizer::optimization_values) {
    	// TODO: this is bad, throw?
    }
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
            .def("targetFunc", (void(Optimizer::*)(const luabind::object &fn))&Optimizer::setTargetFunc, adopt(luabind::result))
            .property("value", &Optimizer::getValue)
            .property("is_optimized", &Optimizer::isOptimized)
            ];
}

void Optimizer::setTargetFunc(const luabind::object &fn) {
    if(luabind::type(fn) == LUA_TFUNCTION) {
        _cb_targetFunc = fn;
    }
}

float Optimizer::callTargetFunc(){
    if(_cb_targetFunc) {
        try {
            float res = luabind::call_function<float>(_cb_targetFunc);
            return res;
        } catch(const std::exception& e){
            //FIXME: Call this function from viewer, or else on error the stack would go nuts
            //showLuaException(e, "Optimization Target Function exception");
        }
    }
    //TODO: Throw an error
    return INFINITY;
}

int getOptimizationValue() {
    return Optimizer::optimization_values[Optimizer::optimization_index]; 
}

int Optimizer::advanceOptimizationValue() {
    Optimizer::optimization_index += 1;
}

bool Optimizer::hasNextValue() {
    return Optimizer::optimization_index + 1 < Optimizer::optimization_values.size();
}

float getBestValue() {
    return Optimizer::best_value;
}
