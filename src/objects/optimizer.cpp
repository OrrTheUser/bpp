#include "optimizer.h"

#include <limits.h>
#include <luabind/adopt_policy.hpp>

Optimizer::Optimizer() : QObject() {
    optimization_value = 0;
    is_optimized = false;
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
int Optimizer::getValue() {
    return optimization_value;
}

void Optimizer::setValue(int value) {
    optimization_value = value;
}

void Optimizer::setTargetFunc(const luabind::object &fn) {
    if(luabind::type(fn) == LUA_TFUNCTION) {
        _cb_targetFunc = fn;
    }
}

bool Optimizer::isOptimized() {
    return is_optimized;
}

void Optimizer::setIsOptimized(bool value) {
    is_optimized = value;
}

int Optimizer::callTargetFunc(){
    if(_cb_targetFunc) {
        try {
            int res = luabind::call_function<int>(_cb_targetFunc);
            return res;
        } catch(const std::exception& e){
            //FIXME: Call this function from viewer, or else on error the stack would go nuts
            //showLuaException(e, "Optimization Target Function exception");
        }
    }
    //TODO: Throw an error
    return INT_MAX;
}
