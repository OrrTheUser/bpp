#ifndef OPTIMIZER_H
#define OPTIMIZER_H

#include <vector>
#include <lua.hpp>
#include <luabind/luabind.hpp>

#include <QObject>

class Optimizer : public QObject {
    Q_OBJECT;

public:
    Optimizer(std::vector<int> optimization_values);
    ~Optimizer();

    static void luaBind(lua_State *s);

    void setTargetFunc(const luabind::object &fn);
    float callTargetFunc();
    int getOptimizationValue();
    void advanceOptimizationValue();
    bool hasNextValue();
    float getBestValue();

protected:
    luabind::object _cb_targetFunc;
    static std::vector<int> optimization_values;
    // TODO: change this to an iterator?
    static int optimization_index;
    static int best_index;
    static float best_value;
};

#endif // OPTIMIZER_H
