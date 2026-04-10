function helper_plot_per_accuracy(snr_dB_vec, per_uncoded, per_coded, acc_uncoded, acc_coded, num_trials)

per_uncoded_plot = per_uncoded;
per_coded_plot = per_coded;

per_uncoded_plot(per_uncoded_plot == 0) = 0.5/num_trials;
per_coded_plot(per_coded_plot == 0) = 0.5/num_trials;

figure
semilogy(snr_dB_vec, per_uncoded_plot, '-o')
hold on
semilogy(snr_dB_vec, per_coded_plot, '-x')
hold off
xlabel('SNR (dB)')
ylabel('Packet Error Rate')
legend('Uncoded', 'Hamming(7,4)', 'Location', 'southwest')
grid on
xlim([snr_dB_vec(1) snr_dB_vec(end)])
xticks(snr_dB_vec)
ax = gca;
ax.Toolbar.Visible = 'off';
exportgraphics(gcf, 'problem_2_2_per.png', 'Resolution', 150)

figure
plot(snr_dB_vec, acc_uncoded, '-o')
hold on
plot(snr_dB_vec, acc_coded, '-x')
hold off
xlabel('SNR (dB)')
ylabel('Truth Payload Accuracy')
legend('Uncoded', 'Hamming(7,4)', 'Location', 'southeast')
grid on
xlim([snr_dB_vec(1) snr_dB_vec(end)])
xticks(snr_dB_vec)
ylim([0.88 1.0])
ax = gca;
ax.Toolbar.Visible = 'off';
exportgraphics(gcf, 'problem_2_2_accuracy.png', 'Resolution', 150)

end
