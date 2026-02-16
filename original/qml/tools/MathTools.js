function toRadians(angle) {
    return angle * (Math.PI / 180)
}

function pita(a, c) {
    var bpow = Math.pow(c, 2) - Math.pow(a, 2)
    return Math.sqrt(bpow)
}

function areTheSame(a, b, precision) {
    if (precision > 0) {
        return Math.abs(a - b) < Number.EPSILON
    } else {
        return a === b
    }
}
