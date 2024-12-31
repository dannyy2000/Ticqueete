"use client";

import Link from "next/link";
import type { NextPage } from "next";
import { useAccount } from "wagmi";
import { Wallet, ShoppingBag, User, ArrowRight } from 'lucide-react';
import { BugAntIcon, MagnifyingGlassIcon } from "@heroicons/react/24/outline";
import { Address } from "~~/components/scaffold-eth";
import image1 from "../app/assets/img1.jpg"
import Image from "next/image";

const Home: NextPage = () => {
  const { address: connectedAddress } = useAccount();


  return (
    <>
      <div className="flex items-center flex-col flex-grow pt-10 px-10">
        {/* <div className="px-5">
          <h1 className="text-center">
            <span className="block text-2xl mb-2">Welcome to</span>
            <span className="block text-4xl font-bold">Scaffold-ETH 2</span>
          </h1>
          <div className="flex justify-center items-center space-x-2 flex-col sm:flex-row">
            <p className="my-2 font-medium">Connected Address:</p>
            <Address address={connectedAddress} />
          </div>

          <p className="text-center text-lg">
            Get started by editing{" "}
            <code className="italic bg-base-300 text-base font-bold max-w-full break-words break-all inline-block">
              packages/nextjs/app/page.tsx
            </code>
          </p>
          <p className="text-center text-lg">
            Edit your smart contract{" "}
            <code className="italic bg-base-300 text-base font-bold max-w-full break-words break-all inline-block">
              YourContract.sol
            </code>{" "}
            in{" "}
            <code className="italic bg-base-300 text-base font-bold max-w-full break-words break-all inline-block">
              packages/hardhat/contracts
            </code>
          </p>
        </div>

        <div className="flex-grow bg-base-300 w-full mt-16 px-8 py-12">
          <div className="flex justify-center items-center gap-12 flex-col sm:flex-row">
            <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">
              <BugAntIcon className="h-8 w-8 fill-secondary" />
              <p>
                Tinker with your smart contract using the{" "}
                <Link href="/debug" passHref className="link">
                  Debug Contracts
                </Link>{" "}
                tab.
              </p>
            </div>
            <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">
              <MagnifyingGlassIcon className="h-8 w-8 fill-secondary" />
              <p>
                Explore your local transactions with the{" "}
                <Link href="/blockexplorer" passHref className="link">
                  Block Explorer
                </Link>{" "}
                tab.
              </p>
            </div>
          </div>
        </div> */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <div>
            <h2 className="text-4xl font-bold mb-6">
              Purchase Your Kiosk Space on the Blockchain
            </h2>
            <p className="text-lg text-gray-600 mb-8">
              Secure your retail space with blockchain technology. Simple, transparent, and efficient.
            </p>
            <div className="flex space-x-4">
              <button 
                // onClick={handleConnectWallet}
                className="flex items-center space-x-2 bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-all"
              >
                <span>Get Started</span>
                <ArrowRight size={20} />
              </button>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-6">
            <div className="bg-white p-6 rounded-xl shadow-lg">
              <ShoppingBag className="w-12 h-12 text-blue-600 mb-4" />
              <h3 className="text-xl font-semibold mb-2">Secure Purchase</h3>
              <p className="text-gray-600">Smart contract enabled transactions for your peace of mind</p>
            </div>
            <div className="bg-white p-6 rounded-xl shadow-lg">
              <User className="w-12 h-12 text-blue-600 mb-4" />
              <h3 className="text-xl font-semibold mb-2">Easy Process</h3>
              <p className="text-gray-600">Simple steps to own your retail space</p>
            </div>
          </div>
          <div className="mt-4">
            <Image src={image1} alt="Kiosk" width={600} />
          </div>
          <div className="mt-4 flex flex-col">
            <h3 className="text-4xl font-bold mb-6">
              Get A convenient and quality retail space for your business in any location of your choice.
            </h3>
            <p className="text-gray-600">
              We offer a seamless process to purchase your retail space using blockchain technology.
            </p>
          </div>
        </div>
      </div>
    </>
  );
};

export default Home;
