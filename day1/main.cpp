#include <charconv>
#include <cmath>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <ranges>
#include <stdexcept>
#include <string>
#include <vector>

struct Rotation
{
    enum class Type
    {
        Left,
        Right
    };

    Type type{};
    int distance{};

    friend std::ostream& operator<<(std::ostream& os, const Rotation& rotation)
    {
        os << "Rotation(type: " << (rotation.type == Type::Left ? "Left" : "Right")
            << ", distance: " << rotation.distance << ")";
        return os;
    }
};

Rotation::Type ToRotationType(const char c)
{
    switch (c)
    {
        case 'L': return Rotation::Type::Left;
        case 'R': return Rotation::Type::Right;
        default: throw std::runtime_error("Invalid rotation type");
    }
}

int ParseToNumber(std::string input)
{
    int number{};
    std::ignore = std::from_chars(input.data(), input.data() + input.size(), number);
    return number;
}

Rotation ParseInput(std::string input)
{
    const auto direction = ToRotationType(input.front());
    auto distance = input | std::views::drop(1) | std::ranges::to<std::string>();

    return Rotation{direction, ParseToNumber(std::move(distance))};
}

std::vector<Rotation> LoadFile(const std::filesystem::path& filepath)
{
    auto rotations = std::vector<Rotation>{};

    auto file = std::ifstream{filepath};
    auto input = std::string{};
    while (std::getline(file, input))
    {
        rotations.push_back(ParseInput(std::move(input)));
    }

    return rotations;
}

void Part1(const std::vector<Rotation>& input)
{
    auto result = 0;
    auto dial = 50;

    for (const auto& rotation : input)
    {
        if (rotation.type == Rotation::Type::Left)
        {
            dial = (dial - rotation.distance) % 100;
        }
        else
        {
            dial = (dial + rotation.distance) % 100;
        }

        if (dial == 0)
        {
            ++result;
        }

    }

    std::cout << "Part 1 solution is " << result << '\n';
}

void Part2(const std::vector<Rotation>& input)
{
    auto result = 0;
    auto dial = 50;

    for (const auto& rotation : input)
    {
        if (rotation.type == Rotation::Type::Left)
        {
            for (auto i = rotation.distance; i > 0; --i)
            {
                dial = (dial - 1) % 100;
                if (dial == 0)
                {
                    ++result;
                }
            }
        }
        else
        {
            for (auto i = rotation.distance; i > 0; --i)
            {
                dial = (dial + 1) % 100;
                if (dial == 0)
                {
                    ++result;
                }
            }
        }
    }

    std::cout << "Part 2 solution is " << result << '\n';
}

int main(int argc, char** argv)
{
    if (argc < 2)
    {
        throw std::runtime_error("Provide filepath");
    }

    const auto input = LoadFile(argv[1]);

    Part1(input);
    Part2(input);
}
