#include <iostream>
#include <fstream>
#include <string>

int main(int argc, char** argv)
{
	if (argc < 4)
	{
		std::cout << "Too few arguements.\n";
		std::cout << "Usage: XorCrypt <Key> <FileIn> <FileOut>\n";
		std::cout << "Note: <Key> is an unsigned char." << std::flush;

		return 0;
	}
	unsigned char Key{};
	try
	{
		Key = (unsigned char)std::stoul(argv[1]);
	}
	catch (const std::exception&)
	{
		std::cout << "Invalid key." << std::endl;
		
		return 0;
	}

	std::string FileIn = argv[2];
	std::string FileOut = argv[3];
	std::ifstream ifsIn;
	std::ofstream ofsOut;
	ifsIn.open(FileIn.c_str(), std::ios::in | std::ios::binary);
	if (!ifsIn)
	{
		std::cout << "Failed to open " << FileIn << std::endl;

		return 0;
	}
	ofsOut.open(FileOut.c_str(), std::ios::out | std::ios::binary | std::ios::trunc);
	if (!ofsOut)
	{
		std::cout << "Failed to open " << FileOut << std::endl;

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
	std::cout << FileIn << " is xored with key " << (unsigned int)Key << " and saved as " << FileOut << std::endl;
}
