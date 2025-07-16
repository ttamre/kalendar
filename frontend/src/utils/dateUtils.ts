/* utils/dateUtils.ts */
export const getPreviousWeekday = (date: Date): Date => {
    const newDate = new Date(date);
    newDate.setDate(newDate.getDate() - 1);

    if (newDate.getDay() === 0) {
        newDate.setDate(newDate.getDate() - 2);
    }
    else if (newDate.getDay() === 6) {
        newDate.setDate(newDate.getDate() - 1);
    }

    return newDate;
};

export const getNextWeekday = (date: Date): Date => {
    const newDate = new Date(date);
    newDate.setDate(newDate.getDate() + 1);

    if (newDate.getDay() === 6) {
        newDate.setDate(newDate.getDate() + 2);
    }
    else if (newDate.getDay() === 0) {
        newDate.setDate(newDate.getDate() + 1);
    }

    return newDate;
};

export const getNearestWeekday = (date: Date): Date => {
    const newDate = new Date(date);
    const day = newDate.getDay();

    if (day === 6) {
        newDate.setDate(newDate.getDate() + 2);
    }
    else if (day === 0) {
        newDate.setDate(newDate.getDate() + 1);
    }

    return newDate;
};

export const readableDateString = (dateString: string): string => {
    const date = new Date(dateString);
    const options: Intl.DateTimeFormatOptions = {
        year: "numeric",
        month: "long",
        day: "numeric"
    }

    return date.toLocaleDateString('en-CA', options)
}