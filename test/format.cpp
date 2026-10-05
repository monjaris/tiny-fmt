#include <string>
#include "tinyfmt/tfmt.hpp"

int main()
{
    tfmt::println("{}", 1);
    tfmt::println("{}", tfmt::format("{}", 2));
}
