#include "{{PACKAGE_NAME}}/{{PACKAGE_NAME}}.h"

#include <cassert>
#include <vector>

int main() {
    std::vector<double> x{1.0, 2.0, 3.0};
    auto result = {{PACKAGE_NAME}}::main_function(x);
    assert(result == x);
    return 0;
}
