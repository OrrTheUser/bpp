#ifndef OPTIMIZER_H
#define OPTIMIZER_H

#include <map>
#include <tuple>
#include <lua.hpp>
#include <luabind/luabind.hpp>

#include <QObject>

class Optimizer : public QObject {
    Q_OBJECT;

public:
    Optimizer();
    ~Optimizer();

    static void luaBind(lua_State *s);

    void setOptimizationValues(const luabind::object &fn);
    void setTargetFunction(const luabind::object &fn);
    void callTargetFunction();
    int getOptimizationValue();
    void advanceOptimizationValue();
    bool hasNextOptimizationValue();
    int getBestOptimizationValue();
    float getBestTargetValue();

protected:
    luabind::object _cb_targetFunc;
    std::map<std::string, std::tuple<int, int, int>> optimization_values;
    std::map<std::string, int> current_optimization_values;
    int best_optimization_value;
    float best_target_value;
};

#endif // OPTIMIZER_H
