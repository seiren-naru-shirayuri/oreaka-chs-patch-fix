#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include <limits>

int main(int argc, char** argv)
{
	switch (argc)
	{
	case 2:
		{
			if (!std::strcmp(argv[1], "/?"))
			{
				std::cout << "Usage: XorCrypt Key FileIn FileOut\n";
				std::cout << "Note: Key is an unsigned char." << std::flush;

				return 0;
			}
			else
			{
				std::cerr << "Too few arguments." << std::endl;

				return 1;
			}
		}
	default:
		{
			if (argc < 4)
			{
				std::cerr << "Too few arguments." << std::endl;

				return 1;
			}
		}
		break;
	}

	unsigned long ulKey{};
	unsigned char Key{};
	try
	{
		ulKey = std::stoul(argv[1]);
	}
	catch (const std::exception&)
	{
		std::cerr << "Invalid key." << std::endl;
		
		return 1;
	}
	if (ulKey > std::numeric_limits<unsigned char>::max())
	{
		std::cerr << "Invalid key." << std::endl;

		return 1;
	}
	else
	{
		Key = static_cast<unsigned char>(ulKey);
	}

	std::ifstream ifs;
	std::ofstream ofs;
	ifs.open(argv[2], std::ios::in | std::ios::binary);
	if (!ifs)
	{
		std::cerr << "Failed to open " << argv[2] << std::endl;

		return 1;
	}
	ofs.open(argv[3], std::ios::out | std::ios::binary | std::ios::trunc);
	if (!ofs)
	{
		std::cerr << "Failed to open " << argv[3] << std::endl;

		return 1;
	}
	unsigned char byte{};
	while (!ifs.eof())
	{
		ifs.read(reinterpret_cast<char*>(&byte), 1);
		if (!ifs.eof())
		{
			byte = byte ^ Key;
			ofs.write(reinterpret_cast<char*>(&byte), 1);
		}
	}
	ifs.close();
	ofs.close();

	std::cout << argv[2] << " is xor-ed with key " << static_cast<unsigned int>(Key) << " and saved as " << argv[3] << std::endl;

	return 0;
}
