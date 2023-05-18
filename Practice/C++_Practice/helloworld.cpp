#include <iostream>
#include <vector>

// typedef std::vector<std::pair<std::string, int>> pairList_t;
// typedef std::string text_t;
// typedef int number_t;
using text_t = std::string;
using number_t = int;

int main()
{
    // Strings
    std::string name = "Marcus";
    std::cout << name << '\n';

    text_t firstName = "Harold";
    number_t age = 19;

    std::cout << firstName << '\n';
    std::cout << age << '\n';

    std::string username;

    std::cout << "What's your username?: ";

    // read lines of text from the terminal (and probably text file)
    // also gets rid of whitespaces
    std::getline(std::cin >> std::ws, name); 

    std::cout << "Hello " << name << '\n';
 
    return 0;
}