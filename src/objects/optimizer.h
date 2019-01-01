#ifndef OPTIMIZER_H
#define OPTIMIZER_H

#include <vector>
#include <lua.hpp>
#include <luabind/luabind.hpp>

#include <QObject>

class Optimizer : public QObject {
    Q_OBJECT;

public:
    Optimizer();
    ~Optimizer();

    static void luaBind(lua_State *s);

    void setOptimizationValues(std::vector<int> optimization_values);
    void setTargetFunction(const luabind::object &fn);
    void callTargetFunction();
    int getOptimizationValue();
    void advanceOptimizationValue();
    bool hasNextOptimizationValue();
    int getBestOptimizationValue();
    float getBestTargetValue();

protected:
    luabind::object _cb_targetFunc;
    std::vector<int> optimization_values;
    // TODO: change this to an iterator?
    int optimization_index;
    int best_optimization_value;
    float best_target_value;
};

#endif // OPTIMIZER_H
