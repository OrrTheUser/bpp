#include "optimizer.h"

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
            .property("value", &Optimizer::getValue)
            ];
}

int Optimizer::getValue() {
    return 5;
}
