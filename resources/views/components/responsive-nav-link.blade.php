<a {{ $attributes->merge(['class' => 'block w-full ps-3 pe-4 py-2 border-l-4 text-start text-base font-medium transition duration-150 ease-in-out ' . ($active ?? false ? 'border-rose-400 text-rose-700 bg-rose-50 focus:outline-none focus:text-rose-800 focus:bg-rose-100 focus:border-rose-700' : 'border-transparent text-gray-600 hover:text-gray-800 hover:bg-gray-50 hover:border-gray-300 focus:outline-none focus:text-gray-800 focus:bg-gray-50 focus:border-gray-300')]) }}>
    {{ $slot }}
</a>
