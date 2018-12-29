#include "optimizer.h"

#include <luabind/adopt_policy.hpp>

Optimizer::Optimizer() : QObject() {
    // Left blank intentionally.
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
	    .def("optimize", &Optimizer::optimize)
            .def("targetFunc", (void(Optimizer::*)(const luabind::object &fn))&Optimizer::setTargetFunc, adopt(luabind::result))
            .property("value", &Optimizer::getValue)
            ];
}

void Optimizer::optimize(const luabind::object &fn) {
    for (int i=1; i < 10; i++) {
	luabind::call_function<void>(fn);
    }
}

int Optimizer::getValue() {
    return optimization_value;
}

void Optimizer::setTargetFunc(const luabind::object &fn) {
    if(luabind::type(fn) == LUA_TFUNCTION) {
        _cb_targetFunc = fn;
    }
}

void Optimizer::callTargetFunc(){
    if(_cb_targetFunc) {
        try {
            int res = luabind::call_function<int>(_cb_targetFunc);
            printf("Callback function returned %d\n", res);
        } catch(const std::exception& e){
            //FIXME: Call this function from viewer, or else on error the stack would go nuts
            //showLuaException(e, "Optimization Target Function exception");
        }
    }
}
