#inisialisasi sumber dan tujuan
gudang <- c('Gudang Ninja Xpress')
tujuan <- c('Galang', 'Bangun Purba', 'Bintang Bayu', 'Gunung Meriah', 'Kotarih',
            'Pagar Merbau', 'Pegajahan', 'Serba Jadi', 'Silinda', 'Silau Kahean',
            'STM Hilir', 'STM Hulu', 'Tiga Juhar')
jmlgudang <- 1
jmltujuan <- 13

#mulai dari data ukuran Large
#mengambil data masukan dari file excel
biaya <- as.matrix(readxl::read_excel('D:/Kerjaan/Project FMOLP/Data bintang FIX.xlsx', sheet = 'Large', range = 'B1:B14'))
waktu <- as.matrix(readxl::read_excel('D:/Kerjaan/Project FMOLP/Data bintang FIX.xlsx', sheet = 'Large', range = 'C1:C14'))
S <- as.matrix(readxl::read_excel('D:/Kerjaan/Project FMOLP/Data bintang FIX.xlsx', sheet = 'Large', range = 'G2'))
A <- as.matrix(readxl::read_excel('D:/Kerjaan/Project FMOLP/Data bintang FIX.xlsx', sheet = 'Large', range = 'D1:D14'))
D <- as.matrix(readxl::read_excel('D:/Kerjaan/Project FMOLP/Data bintang FIX.xlsx', sheet = 'Large', range = 'E1:E14'))

#inisialisasi variabel deviational non negatif
x <- 6
y <- 4
z <- 2
t <- t(waktu)

#fungsi tujuan memaksimalkan L
dvar <- matrix(0, nrow = 1, ncol = 20)
for (i in 1:jmlgudang) {
  for (j in 1:jmltujuan) {
    dvar[i, j] <- 0
  }
}

for (i in 1:x) {
  dvar[1, 13 + i] <- 0
}

dvar[1, 20] <- 1
fo <- dvar

#membuat array untuk variabel keputusan, batas atas, dan batas bawah
dvar <- matrix(0, nrow = 1, ncol = 20)
Q <- matrix(0, nrow = 0, ncol = 20)
bU <- numeric()
bL <- numeric()

#memasukkan batasan pertama FMOLP
c <- t(biaya)
dvar <- matrix(0, nrow = 1, ncol = 20)
for (i in 1:jmlgudang) {
  for (j in 1:jmltujuan) {
    dvar[i, j] <- c[i,j] * 0.0000000035
  }
}

dvar[1, 14] <- 0.000000001
dvar[1, 15] <- -0.000000001
dvar[1, 16] <- 0.0000000005
dvar[1, 17] <- -0.0000000005

for (i in 1:z) {
  dvar[1, 17 + i] <- 0
}

dvar[1, 20] <- 1
Q <- rbind(Q, dvar)
bU <- c(bU, Inf)
bL <- c(bL, 1.53)

#memasukkan batasan ketiga FMOLP
dvar <- matrix(0, nrow = 1, ncol = 20)
for (i in 1:jmlgudang) {
  for (j in 1:jmltujuan) {
    dvar[i, j] <- c[i,j]
  }
}

dvar[1, 14] <- 1
dvar[1, 15] <- -1
Q <- rbind(Q, dvar)
bU <- c(bU, 280000000)
bL <- c(bL, 280000000)

#lanjutkan dengan batasan keempat, kelima, keenam, ketujuh, dan kedelapan FMOLP

#eksekusi model
#IntVars <- rep(FALSE, 20)
#Prob <- mipAssign(fo, Q, bL, bU, x_L, x_U, NULL, NULL, NULL, NULL, IntVars, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
#Result <- mipSolve(Prob)
#x <- Result$x_k
#fval <- Result$f_k

library(lpSolve)
#eksekusi model
IntVars <- rep(FALSE, 20)
