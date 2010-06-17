#ifndef Rose_SMTSolver_H
#define Rose_SMTSolver_H

#include "InsnSemanticsExpr.h"

/** Interface to Satisfiability Modulo Theory (SMT) solvers. */
class SMTSolver {
public:
    struct Exception {
        Exception(const std::string &mesg): mesg(mesg) {}
        friend std::ostream& operator<<(std::ostream&, const SMTSolver::Exception&);
        std::string mesg;
    };
    
    typedef std::set<uint64_t> Definitions;     /**< Free variables that have been defined. */

    SMTSolver(): debug(NULL) {}

    virtual ~SMTSolver() {}

    /** Determines if the specified expression is satisfiable. Throws Exception if satisfiability cannot be determined. */
    virtual bool satisfiable(const InsnSemanticsExpr::TreeNode *expr);

    /** Generates an input file for for the solver. Usually the input file will be SMT-LIB format, but subclasses might
     *  override this to generate some other kind of input. Throws Excecption if the solver does not support an operation that
     *  is necessary to determine the satisfiability. */
    virtual void generate_file(std::ostream&, const InsnSemanticsExpr::TreeNode *expr, Definitions*) = 0;

    /** Given the name of a configuration file, return the command that is needed to run the solver. The first line
     *  of stdout emitted by the solver should be the word "sat" or "unsat". */
    virtual std::string get_command(const std::string &config_name) = 0;

    /** Turns debugging on or off. */
    void set_debug(FILE *f) { debug = f; }

    /** Obtain current debugging setting. */
    FILE *get_debug() const { return debug; }

private:
    FILE *debug;
};

#endif