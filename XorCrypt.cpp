#include <iostream>
#include <fstream>
#include <string>
#include <limits>

int main(int argc, char** argv)
{
	if (argc < 4)
	{
		std::cout << "Too few arguments.\n";
		std::cout << "Usage: XorCrypt <Key> <FileIn> <FileOut>\n";
		std::cout << "Note: <Key> is an unsigned char." << std::flush;

		return 0;
	}
	unsigned long ulKey{};
	unsigned char Key{};
	try
	{
		ulKey = std::stoul(argv[1]);
	}
	catch (const std::exception&)
	{
		std::cout << "Invalid key." << std::endl;
		
		return 0;
	}
	if (ulKey > std::numeric_limits<unsigned char>::max())
	{
		std::cout << "Invalid key." << std::endl;

		return 0;
	}
	else
	{
		Key = (unsigned char)ulKey;
	}

	std::ifstream ifsIn;
	std::ofstream ofsOut;
	ifsIn.open(argv[2], std::ios::in | std::ios::binary);
	if (!ifsIn)
	{
		std::cout << "Failed to open " << argv[2] << std::endl;

		return 0;
	}
	ofsOut.open(argv[3], std::ios::out | std::ios::binary | std::ios::trunc);
	if (!ofsOut)
	{
		std::cout << "Failed to open " << argv[3] << std::endl;

		return 0;
	}
	unsigned char byte{};
	while (!ifsIn.eof())
	{
		ifsIn.read((char*)&byte, 1);
		if (!ifsIn.eof())
		{
			byte = byte ^ Key;
			ofsOut.write((char*)&byte, 1);
		}
	}
	ifsIn.close();
	ofsOut.close();
	std::cout << argv[2] << " is xored with key " << (unsigned int)Key << " and saved as " << argv[3] << std::endl;
}
