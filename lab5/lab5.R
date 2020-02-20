results = read.csv("gsl_blas_out.csv", sep = ";")

avg_results = aggregate(cbind(Time_1st_level, Time_2nd_level) ~ Size, data = results, FUN = mean)

avg_results$sd_1st_level = aggregate(Time_1st_level ~ Size, data = results, FUN = sd)$Time_1st_level
avg_results$sd_2nd_level = aggregate(Time_2nd_level ~ Size, data = results, FUN = sd)$Time_2nd_level

ggplot(avg_results, aes(Size,Time_1st_level,colour = "level_1st")) + 
  scale_colour_manual(name="Different BLAS levels", values=c(level_1st="red", level_2nd="blue", fit_for_1st_level = "darkred", fit_for_2nd_level= "darkblue")) + 
  geom_point() + 
  geom_errorbar(aes(ymin = Time_1st_level - sd_1st_level, ymax = Time_1st_level + sd_1st_level), colour = "black")
last_plot() + geom_point(data = avg_results, aes(Size, Time_2nd_level, colour = 'level_2nd')) + geom_errorbar(aes(ymin = Time_2nd_level - sd_2nd_level, ymax = Time_2nd_level + sd_2nd_level), colour = "black")
last_plot() + ylab("Time (ms)") + xlab("Array/vector size")

x = avg_results$Size
y_1st_level = avg_results$Time_1st_level
y_2nd_level = avg_results$Time_2nd_level
data_to_fit_1st_lev = data.frame(x, y_1st_level)
data_to_fit_2nd_lev = data.frame(x, y_2nd_level)

fit_1st = lm(y_1st_level ~ poly(x, 1, raw = TRUE), data = data_to_fit_1st_lev)
fit_2nd = lm(y_2nd_level ~ poly(x, 2, raw = TRUE), data = data_to_fit_2nd_lev)

fitted_data_1st = data.frame(x = seq(0, 5000, length.out = 2500))
fitted_data_1st$y = predict(fit_1st, fitted_data_1st)

fitted_data_2nd = data.frame(x = seq(0, 5000, length.out = 2500))
fitted_data_2nd$y = predict(fit_2nd, fitted_data_2nd)

last_plot() + geom_line(data = fitted_data_1st, aes(x,y, colour = "fit_for_1st_level"))
last_plot() + geom_line(data = fitted_data_2nd, aes(x,y, colour = "fit_for_2nd_level"))