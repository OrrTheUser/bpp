#ifndef OBJECT_H
#define OBJECT_H

#include <lua.hpp>
#include <luabind/luabind.hpp>

#include <QObject>

#include <QColor>
#include <QTextStream>

#include <btBulletDynamicsCommon.h>

class Object;

std::ostream& operator<<(std::ostream&, const Object& obj);

namespace luabind
{
  template <>
    struct default_converter<QString>
	: native_converter_base<QString>
  {
	static int compute_score(lua_State* L, int index) {
	  return lua_type(L, index) == LUA_TSTRING ? 0 : -1;
	}
	
	QString from(lua_State* L, int index) {
	  return QString(lua_tostring(L, index));
	}
	
	void to(lua_State* L, QString const& x) {
	  lua_pushstring(L, x.toAscii());
	}
  };
  
  template <>
    struct default_converter<QString const>
	: default_converter<QString>
  {};

  template <>
    struct default_converter<QString const&>
	: default_converter<QString>
  {};
}

class Object : public QObject {
 Q_OBJECT;

 public:
  Object(QObject *parent = NULL);
  virtual ~Object();

  void render(QTextStream *s);
  void setColor(int r, int g, int b);
  void setColor(QColor col);
  void setColorString(QString c);

  QColor getColor() const;
  QString getColorString() const;

  void setPosition(btScalar x, btScalar y, btScalar z);
  void setPosition(btVector3& v);

  btVector3 getPosition() const;

  void setRotation(btVector3 axis, btScalar angle);
  void setRotation(btQuaternion rot);
  btQuaternion getRotation() const;

  void setTransform(btTransform trans);
  btTransform getTransform() const;

  void setMass(btScalar mass);
  btScalar getMass() const;

  void setLinearVelocity(btVector3 vector);
  btVector3 getLinearVelocity() const;

  void setPovPhotons(bool _photons_enable = false,
		     bool _photons_reflection = false,
		     bool _photons_refraction = false);

  virtual QString getPovPhotons() const;

  void setTexture(QString texture);
  QString getTexture() const;

  void setFinish(QString finish);
  QString getFinish() const;

  void setScale(QString scale);
  QString getScale() const;

  btRigidBody      *body;
  btCollisionShape *shape;

  static void luaBind(lua_State *s);

  virtual QString toString() const;

 protected:
  virtual void renderInLocalFrame(QTextStream *s) const;
	
  unsigned char color[3];

  bool photons_enable;
  bool photons_reflection;
  bool photons_refraction;

  QString mTexture;
  QString mScale;
  QString mFinish;
};

#endif // OBJECT_H
