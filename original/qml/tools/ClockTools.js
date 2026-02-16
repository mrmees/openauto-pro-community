function get12HTime(date) {
    var hours = date.getHours()
    var minutes = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();

    var hoursModulo = hours % 12;
    var hours12 = (hoursModulo === 0 ? 12 : hoursModulo);
    return hours12 + ":" + minutes;
}

function get24HTime(date) {
    var hours = date.getHours()
    var minutes = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
    return (hours < 10 ? "0" + hours : hours) + ":" + minutes
}
