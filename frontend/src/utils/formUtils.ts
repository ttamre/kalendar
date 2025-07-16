/* Form utils */

export const readablePhoneNumber = (phone: string): string => {
    const digits = phone.replace(/\D/g, '');

    if (digits.length === 10) {
        return `(${digits.slice(0, 3)}) ${digits.slice(3, 6)}-${digits.slice(6)}`;
    }

    if (digits.length === 11) {
        return `+${digits.slice(0, 1)} (${digits.slice(1, 4)}) ${digits.slice(4, 7)}-${digits.slice(7)}`;
    }

    return phone
}

export const readableStatus = (status: string): string => {
    return status.replace("_", " ")
}