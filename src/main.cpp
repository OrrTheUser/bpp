#define APP_VERSION QString("v0.0.4")
#define APP_NAME QString("bpp")
#define APP_NAME_FULL tr("Bullet Physics Playground")
#define APP_ORGANIZATION QString("bullet-physics-playground.github.io")

#include <math.h>

#include <QApplication>

#include <QCommandLineParser>
#include <QCommandLineOption>
#include <GL/freeglut.h>

#include "gui.h"
#include "viewer.h"

QTextStream& qStdOut() { static QTextStream ts( stdout ); return ts; }
QTextStream& qStdErr() { static QTextStream ts( stderr ); return ts; }

QString withoutExtension(const QString & fileName) {
    return fileName.left(fileName.lastIndexOf("."));
}

/*
This Function runs the simulation of the scene.
The first 4 arguments are system things we just pass along.
The other two are ours:
    optimization_value - the current value the optimizer is trying out.
    optimized - whether this is the final optimized value or not (for rendering)
*/
Viewer* run_simulation(
    QSettings* settings,
    const QCommandLineParser& parser,
    const QString& txt,
    const QStringList& lua,
    Optimizer& optimizer
) {
    Viewer *v = new Viewer(NULL, settings);
    v->setOptimizer(&optimizer);
    QObject::connect(v, &Viewer::scriptHasOutput, [=](QString o) {
	qStdOut() << o << endl;
    });
    QObject::connect(v, &Viewer::statusEvent, [=](QString e) {
	qStdErr() << e << endl;
    });

    if (parser.isSet("verbose"))  {
	QObject::connect(v, &Viewer::scriptStarts, [=]() {
	    qStdErr() << "scriptStarts()" << endl;
	});
	QObject::connect(v, &Viewer::scriptStopped, [=]() {
	    qStdErr() << "scriptStoppend()" << endl;
	});
	QObject::connect(v, &Viewer::scriptFinished, [=]() {
	    qStdErr() << "scriptFinished()" << endl;
	});
    }

    if (!lua.isEmpty()) {
	v->setScriptName(withoutExtension(lua[0]));
    } else {
	v->setScriptName("stdin");
    }

    v->setSavePOV(parser.isSet("export"));

    v->parse(txt);
    v->startSim();
    return v;
}

int main(int argc, char **argv) {
    QSharedPointer<QCoreApplication> app;

    // workaround for https://forum.qt.io/topic/53298/qcommandlineparser-to-select-gui-or-non-gui-mode

    // On Linux: enable printing of version and help without DISPLAY variable set

    bool runCore = false;
    for (int i = 0; i < argc; i++) {
        if (QString(argv[i]) == "-h" ||
                QString(argv[i]) == "--help" ||
                QString(argv[i]) == "-v" ||
                QString(argv[i]) == "--version" ) {
            runCore = true;
            break;
        }
    }

    if (runCore) {
        app = QSharedPointer<QCoreApplication>(new QCoreApplication(argc, argv));
    } else {
        app = QSharedPointer<QCoreApplication>(new QApplication(argc, argv));
    }

    // end workaround

    QSettings *settings = new QSettings(APP_ORGANIZATION, APP_NAME);

    app->setApplicationName(APP_NAME);
    app->setApplicationVersion(APP_VERSION);

    QCommandLineParser parser;

    parser.setApplicationDescription(QObject::tr("The Bullet Physics Playground"));
    parser.addHelpOption();
    parser.addVersionOption();

    QCommandLineOption luaOption(QStringList() << "f" << "file",
                                 QObject::tr("Runs the given Lua script without GUI."), "file");
    QCommandLineOption luaExpressionOption(QStringList() << "l" << "lua",
                                           QObject::tr("Runs the given Lua expression without GUI."), "expression");
    QCommandLineOption luaStdinOption(QStringList() << "i" << "stdin",
                                      QObject::tr("Interprets Lua code from stdin without GUI."));
    QCommandLineOption nOption(QStringList() << "n" << "frames",
                               QObject::tr("Number of frames to simulate."), "n", "10");
    QCommandLineOption povExportOption(QStringList() << "e" << "export",
                                     QObject::tr("Export frames to POV-Ray."));
    QCommandLineOption verboseOption(QStringList() << "V" << "verbose",
                                     QObject::tr("Verbose output."));
    parser.addOption(luaOption);
    parser.addOption(luaExpressionOption);
    parser.addOption(luaStdinOption);
    parser.addOption(nOption);
    parser.addOption(povExportOption);
    parser.addOption(verboseOption);

    parser.process(*app);

    if (!parser.isSet(luaOption) && !parser.isSet(luaStdinOption) && !parser.isSet(luaExpressionOption)) {
        Gui *g;

        glutInit(&argc,argv);
        glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH);

        if (!QIcon::hasThemeIcon("document-new")) {
            QIcon::setThemeName("humanity");
        }

        g = new Gui(settings);
        g->show();

        return app->exec();
    } else {
        QStringList lua = parser.values(luaOption);
        QStringList luaExpression = parser.values(luaExpressionOption);

        if (lua.isEmpty() && luaExpression.isEmpty() && !parser.isSet(luaStdinOption)) {
            qStdErr() << QObject::tr("Error: Option '--lua' requires a Lua script file as an argument. Exiting.") << endl;
            return EXIT_FAILURE;
        }

        QString txt;

        if (!lua.isEmpty()) {
            QFile file(lua[0]);
            if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
                QString errMsg = file.errorString();
                qStdErr() << QObject::tr("Error: reading '%1': %2. Exiting.").arg(lua[0], errMsg) << endl;
                return EXIT_FAILURE;
            }

            QTextStream in(&file);
            txt = in.readAll();
            file.close();
        }

        if (parser.isSet(luaStdinOption)) {
            QTextStream in(stdin);
            txt += "\n" + in.readAll();
        }

        if (!luaExpression.isEmpty()) {
            txt += "\n" + luaExpression[0];
        }

        int n = parser.value(nOption).toInt();
        if (n < 0) {
            qStdErr() << QObject::tr("Error: -n must be >= 0. Exiting.") << endl;
            return EXIT_FAILURE;
        }


	Optimizer optimizer;

         /* TODO: make this section less hack-y:
         maybe parse a command line argument "optimize" and only run this part when it's on, etc.
         */
        while (optimizer.hasNextOptimizationValue()) {
            Viewer* v = run_simulation(settings, parser, txt, lua, optimizer);
            // Currently setting the iteration number to be the guessed value
            // TODO: I think this implementation only works when we optimize speed/forces, not positions / size / etc.

            for (int j = 0; j < n; ++j) {
                v->animate();
                optimizer.callTargetFunction();
            }
            //printf("For value %d, the best contender for target func is %.6f from frame %d\n", i, best_target_func_value_for_this_iteration, frame);             
	    optimizer.advanceOptimizationValue();
            v->close();
        }

        //printf("The final target func value we got was %.6f, and we achieved it with the value %d\n", best_target_func_value, best_optimized_value);

        // Run the simulation again, for rendering the successful value
	Viewer* v = run_simulation(settings, parser, txt, lua, optimizer);
        for (int j = 0; j < n; ++j) {
            v->animate();
        }
       
        v->close();

        QMetaObject::invokeMethod(qApp, "quit", Qt::QueuedConnection);

        return app->exec();
    }
}
