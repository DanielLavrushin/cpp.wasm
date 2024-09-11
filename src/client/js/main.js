let loadFile = ()=> {
    const input = document.getElementById('fileInput');
    if (input.files.length > 0) {
        const file = input.files[0];
        const reader = new FileReader();
        
        reader.onload = function() {
            const arrayBuffer = reader.result;
            const uint8Array = new Uint8Array(arrayBuffer);
            
            const dataPtr = allocateUint8Array(uint8Array);
            const sum = Module.ccall('processFile', 'number', ['number', 'number'], [dataPtr, uint8Array.length]);
            console.log("Sum of file bytes:", sum);
            Module._free(dataPtr); // Free memory in WASM module
        };

        reader.readAsArrayBuffer(file);
    } else {
        alert('Please select a file first.');
    }
};

function allocateUint8Array(uint8Array) {
    const numBytes = uint8Array.length;
    const dataPtr = Module._malloc(numBytes); // Allocate memory in the WASM module
    const dataOnHeap = new Uint8Array(Module.HEAPU8.buffer, dataPtr, numBytes); // Point to the same memory
    dataOnHeap.set(uint8Array); // Copy data to heap
    return dataPtr;
}
