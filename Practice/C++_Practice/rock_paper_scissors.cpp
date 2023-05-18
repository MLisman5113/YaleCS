#include <iostream>
#include <ctime>

char get_user_choice();
char get_computer_choice();
void show_choice(char choice);
void choose_winner (char player, char computer);

int main()
{
    char player;
    char computer;

    player = get_user_choice();
    std::cout << "Your choice: ";
    show_choice(player);

    computer = get_computer_choice();
    std::cout << "Computer's choice: ";
    show_choice(computer);

    choose_winner(player, computer);


    return 0;
}

char get_user_choice()
{
    char player;
    std::cout << "Rock-Paper-Scissors Game!\n";

    do
    {
        std::cout << "Choose one of the following\n";
        std::cout << "'r' for rock\n";
        std::cout << "'p' for paper\n";
        std::cout << "'s' for scissors\n";
        std::cin >> player;
    } while (player != 'r' && player != 'p' && player != 's');
    
    return player;
}

char get_computer_choice()
{
    srand(time(0));
    int num = rand() % 3 + 1;

    switch(num)
    {
        case 1: return 'r';
                break;
        case 2: return 'p';
                break;
        case 3: return 's';
                break;
    }
    return 0;
}

void show_choice(char choice)
{
    switch(choice)
    {
        case 'r': std::cout << "Rock\n";
                break;
        case 's': std::cout << "Scissors\n";
                break;
        case 'p': std::cout << "Paper\n";
                break;
    }
}

void choose_winner (char player, char computer)
{
    switch(player)
    {
        case 'r':   if(computer == 'r') {
                        std::cout << "It's a tie!\n";
                    }
                    else if (computer == 'p')
                    {
                        std::cout << "You lose!\n";
                    } 
                    else
                    {
                        std::cout << "You win!\n";
                    }
                    break;
        case 'p':   if(computer == 'p') {
                        std::cout << "It's a tie!\n";
                    }
                    else if (computer == 's')
                    {
                        std::cout << "You lose!\n";
                    } 
                    else
                    {
                        std::cout << "You win!\n";
                    }
                    break;
        case 's':   if(computer == 's') {
                        std::cout << "It's a tie!\n";
                    }
                    else if (computer == 'r')
                    {
                        std::cout << "You lose!\n";
                    } 
                    else
                    {
                        std::cout << "You win!\n";
                    }
                    break;      
    }

}
