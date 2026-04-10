function helper_plot_per_accuracy(snr_dB_vec, per_uncoded, per_coded, acc_uncoded, acc_coded)

figure
plot(snr_dB_vec, per_uncoded, '-o')
hold on
plot(snr_dB_vec, per_coded, '-x')
hold off
xlabel('SNR (dB)')
ylabel('Packet Error Rate')
legend('Uncoded', 'Hamming(7,4)', 'Location', 'southwest')
grid on
ax = gca;
ax.Toolbar.Visible = 'off';
exportgraphics(gcf, 'problem_2_2_per.png', 'Resolution', 150)

figure
plot(snr_dB_vec, acc_uncoded, '-o')
hold on
plot(snr_dB_vec, acc_coded, '-x')
hold off
xlabel('SNR (dB)')
ylabel('Payload Bit Accuracy')
legend('Uncoded', 'Hamming(7,4)', 'Location', 'southeast')
grid on
ax = gca;
ax.Toolbar.Visible = 'off';
exportgraphics(gcf, 'problem_2_2_accuracy.png', 'Resolution', 150)

end
