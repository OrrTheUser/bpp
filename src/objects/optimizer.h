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

    void setTargetFunc(const luabind::object &fn);
    float callTargetFunc();
    int getValue();
    void setValue(int value);
    bool isOptimized();
    void setIsOptimized(bool value);

protected:
    luabind::object _cb_targetFunc;
    int optimization_value;
    bool is_optimized;
};

#endif // OPTIMIZER_H
