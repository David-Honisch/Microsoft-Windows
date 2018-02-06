#include <iostream>     // std::cin, std::cout
#include <fstream>      // std::ofstream

int main () {
  std::ofstream outfile ("error.log");
  char ch;

  std::cout << "Type some text (type a dot to finish):\n";
  do {
    ch = std::cin.get();
    outfile.put(ch);
  } while (ch!='.');

  return 0;
}
