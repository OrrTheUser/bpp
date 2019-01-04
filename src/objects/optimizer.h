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
    void addOptimizationValues(
	const std::string name,
        const luabind::object& min_value_object,
	const luabind::object& max_value_object,
        const luabind::object& step_object
    );
    void setTargetFunction(const luabind::object &fn);
    void callTargetFunction();
    int getOptimizationValue(std::string name);
    void advanceOptimizationValue();
    bool hasNextOptimizationValue();
    int getBestOptimizationValue(std::string name);
    float getBestTargetValue();
    bool isOptimized();

protected:
    luabind::object _cb_targetFunc;
    std::map<std::string, std::tuple<int, int, int>> optimization_values;
    std::map<std::string, int> current_optimization_values;
    std::map<std::string, int> best_optimization_values;
    float best_target_value;
    bool initialized;
};

#endif // OPTIMIZER_H
