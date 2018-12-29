#ifndef OPTIMIZER_H
#define OPTIMIZER_H

#include <lua.hpp>
#include <luabind/luabind.hpp>

#include <QObject>

class Optimizer : public QObject {
    Q_OBJECT;

public:
    Optimizer();
    ~Optimizer();

    static void luaBind(lua_State *s);

    void optimize(const luabind::object &fn);
    void setTargetFunc(const luabind::object &fn);
    void callTargetFunc();
    int getValue();

protected:
    luabind::object _cb_targetFunc;
    int optimization_value;
};

#endif // OPTIMIZER_H
