#ifndef PLANE_H
#define PLANE_H

#include "object.h"

#include <btBulletDynamicsCommon.h>

class Plane : public Object
{
 public:
  Plane(btScalar nx, btScalar ny, btScalar nz, btScalar nConst,	btScalar size);

  void setPigment(QString pigment);
  
 protected:
  virtual void renderInLocalFrame(QTextStream *s) const;
  
  btScalar       size;

  QString mPigment;
};

#endif // PLANE_H
